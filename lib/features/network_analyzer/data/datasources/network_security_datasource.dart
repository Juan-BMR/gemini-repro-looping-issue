import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/network_security_report_model.dart';
import '../../domain/entities/network_security_report.dart';

abstract class NetworkSecurityDataSource {
  /// Checks if we can perform network scanning (permissions, capabilities)
  Future<bool> canPerformNetworkScanning();

  /// Requests permissions needed for network scanning
  Future<bool> requestScanningPermissions();

  /// Scans for available WiFi networks
  Future<List<NetworkSecurityReportModel>> scanNetworks();

  /// Gets information about the currently connected network
  Future<NetworkSecurityReportModel> getCurrentNetworkSecurity();
}

class NetworkSecurityDataSourceImpl implements NetworkSecurityDataSource {
  final WiFiScan _wifiScan = WiFiScan.instance;

  @override
  Future<bool> canPerformNetworkScanning() async {
    final canStartScan = await _wifiScan.canStartScan();
    return canStartScan == CanStartScan.yes;
  }

  @override
  Future<bool> requestScanningPermissions() async {
    // Request location permission (required for WiFi scanning)
    var status = await Permission.locationWhenInUse.request();

    // Some devices might also need storage permissions
    await Permission.storage.request();

    // For Android 10+ we need fine location
    if (status != PermissionStatus.granted) {
      status = await Permission.location.request();
    }

    return status == PermissionStatus.granted;
  }

  @override
  Future<List<NetworkSecurityReportModel>> scanNetworks() async {
    final canStartScan = await _wifiScan.canStartScan();

    if (canStartScan == CanStartScan.yes) {
      // Start the scan
      await _wifiScan.startScan();

      // Get the results
      final canGetResults = await _wifiScan.canGetScannedResults();
      if (canGetResults == CanGetScannedResults.yes) {
        final accessPoints = await _wifiScan.getScannedResults();

        // Convert access points to our models
        return accessPoints
            .map((ap) => NetworkSecurityReportModel.fromWiFiAccessPoint(ap))
            .toList();
      }
    }

    // Return empty list if scanning failed
    return [];
  }

  @override
  Future<NetworkSecurityReportModel> getCurrentNetworkSecurity() async {
    final canGetResults = await _wifiScan.canGetScannedResults();

    if (canGetResults == CanGetScannedResults.yes) {
      final accessPoints = await _wifiScan.getScannedResults();

      // Try to find the connected network
      // This is a simplification - in a real app, you would need to determine
      // which network is currently connected via platform channels

      // For now, we'll assume the one with the strongest signal is connected
      if (accessPoints.isNotEmpty) {
        var strongestAP = accessPoints[0];
        int strongestSignal =
            strongestAP.level != null ? strongestAP.level! : -100;

        for (final ap in accessPoints) {
          final signal = ap.level != null ? ap.level! : -100;
          if (signal > strongestSignal) {
            strongestSignal = signal;
            strongestAP = ap;
          }
        }

        return NetworkSecurityReportModel.fromWiFiAccessPoint(strongestAP);
      }
    }

    // Return a "not connected" report if we couldn't get the current network
    return NetworkSecurityReportModel(
      ssid: 'Not Connected',
      bssid: '00:00:00:00:00:00',
      signalStrength: -100,
      frequency: 0,
      channel: 0,
      encryptionType: EncryptionType.unknown,
      securityLevel: SecurityLevel.critical,
      vulnerabilities: const [],
      recommendations: const [],
    );
  }
}
