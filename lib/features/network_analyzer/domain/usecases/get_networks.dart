import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/network.dart';
import '../entities/security_level.dart';
import '../repositories/network_repository.dart';

class GetNetworks implements UseCase<List<Network>, void> {
  final NetworkRepository _repository;

  GetNetworks(this._repository);

  @override
  Future<List<Network>> call([void params]) async {
    return await _repository.getNetworks();
  }
}

// For the example, we'll create a mock implementation
final networkRepositoryProvider = Provider<NetworkRepository>((ref) {
  return MockNetworkRepository();
});

final getNetworksProvider = Provider<GetNetworks>((ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return GetNetworks(repository);
});

// Mock repository implementation for demo purposes
class MockNetworkRepository implements NetworkRepository {
  @override
  Future<List<Network>> getNetworks() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    return [
      Network(
        ssid: 'HomeNetwork',
        bssid: 'AA:BB:CC:DD:EE:FF',
        encryption: 'WPA2-PSK',
        signalStrength: -45,
        frequency: 5240,
        channel: 48,
        securityLevel: SecurityLevel.secure,
        ipAddress: '192.168.1.5',
        bandwidth: '80 MHz',
        standard: '802.11ac',
        linkSpeed: '867 Mbps',
        latency: 12,
        passwordStrength: 'Strong',
        routerSecurityLevel: 'Good',
        openPorts: [],
        connectedDevices: [],
      ),
      Network(
        ssid: 'CoffeeShopWiFi',
        bssid: 'FF:EE:DD:CC:BB:AA',
        encryption: 'WPA2-PSK',
        signalStrength: -65,
        frequency: 2437,
        channel: 6,
        securityLevel: SecurityLevel.acceptable,
        bandwidth: '20 MHz',
        standard: '802.11n',
      ),
      Network(
        ssid: 'GuestNetwork',
        bssid: '11:22:33:44:55:66',
        encryption: 'WPA-PSK',
        signalStrength: -58,
        frequency: 2412,
        channel: 1,
        securityLevel: SecurityLevel.vulnerable,
      ),
      Network(
        ssid: 'PublicWiFi',
        bssid: '66:55:44:33:22:11',
        encryption: 'Open',
        signalStrength: -72,
        frequency: 2437,
        channel: 6,
        securityLevel: SecurityLevel.critical,
      ),
      Network(
        ssid: 'SecurityPlus',
        bssid: 'AB:CD:EF:12:34:56',
        encryption: 'WPA3-PSK',
        signalStrength: -52,
        frequency: 5745,
        channel: 149,
        securityLevel: SecurityLevel.optimal,
        bandwidth: '160 MHz',
        standard: '802.11ax',
        linkSpeed: '2400 Mbps',
      ),
    ];
  }

  @override
  Future<Network> analyzeNetworkSecurity(Network network) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // In a real app, this would perform a detailed security analysis
    // For demo, we'll just return the network with the same security level
    return network;
  }
}
