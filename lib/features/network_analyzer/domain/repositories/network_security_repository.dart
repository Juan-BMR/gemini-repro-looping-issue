import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/network_security_report.dart';

abstract class NetworkSecurityRepository {
  /// Scans available WiFi networks and returns their security reports
  Future<Either<Failure, List<NetworkSecurityReport>>> scanNetworks();

  /// Gets detailed security information about the currently connected network
  Future<Either<Failure, NetworkSecurityReport>> getCurrentNetworkSecurity();

  /// Checks if the device can perform network scanning (permissions, capabilities)
  Future<Either<Failure, bool>> canPerformNetworkScanning();
}
