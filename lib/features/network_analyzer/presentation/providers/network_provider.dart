import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/network.dart';
import '../../domain/entities/security_level.dart';
import '../../domain/usecases/get_networks.dart';
import '../../domain/usecases/analyze_network_security.dart';
import '../../domain/repositories/network_repository.dart';

// Repository provider
final networkRepositoryProvider = Provider<NetworkRepository>((ref) {
  // Return a mock implementation for demonstration
  return MockNetworkRepository();
});

// Network list state
final networksProvider =
    StateNotifierProvider<NetworksNotifier, AsyncValue<List<Network>>>((ref) {
  final getNetworks = ref.watch(getNetworksProvider);
  return NetworksNotifier(getNetworks);
});

// Selected network state
final selectedNetworkProvider = StateProvider<Network?>((ref) => null);

// Network security analysis state
final networkSecurityProvider =
    FutureProvider.family<SecurityLevel, Network>((ref, network) async {
  final analyzeNetworkSecurity = ref.watch(analyzeNetworkSecurityProvider);
  return await analyzeNetworkSecurity(network);
});

// Networks notifier
class NetworksNotifier extends StateNotifier<AsyncValue<List<Network>>> {
  final GetNetworks _getNetworks;

  NetworksNotifier(this._getNetworks) : super(const AsyncValue.loading()) {
    loadNetworks();
  }

  Future<void> loadNetworks() async {
    state = const AsyncValue.loading();
    try {
      final networks = await _getNetworks();
      state = AsyncValue.data(networks);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshNetworks() async {
    try {
      final networks = await _getNetworks();
      state = AsyncValue.data(networks);
    } catch (e, stackTrace) {
      // Keep old data and just show error
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void addNetwork(Network network) {
    final currentNetworks = state.value ?? [];
    state = AsyncValue.data([...currentNetworks, network]);
  }

  void updateNetwork(Network updatedNetwork) {
    final currentNetworks = state.value ?? [];
    state = AsyncValue.data(
      currentNetworks.map((network) {
        return network.bssid == updatedNetwork.bssid ? updatedNetwork : network;
      }).toList(),
    );
  }
}

// Mock implementation of GetNetworks use case for demonstration
final getNetworksProvider = Provider<GetNetworks>((ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return GetNetworks(repository);
});

// Mock implementation of AnalyzeNetworkSecurity use case for demonstration
final analyzeNetworkSecurityProvider = Provider<AnalyzeNetworkSecurity>((ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return AnalyzeNetworkSecurity(repository);
});

// Mock repository implementation for demonstration purposes
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
