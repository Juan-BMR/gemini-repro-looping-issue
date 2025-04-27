import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/network_security_report.dart';
import '../../domain/usecases/scan_networks.dart';
import '../../domain/usecases/get_current_network_security.dart';
import '../../../network_analyzer/data/repositories/network_security_repository_impl.dart';
import '../../../../core/di/injection_container.dart';

// Repository provider
final networkSecurityRepositoryProvider =
    Provider<NetworkSecurityRepositoryImpl>((ref) {
  return sl<NetworkSecurityRepositoryImpl>();
});

// Use case providers
final scanNetworksUseCaseProvider = Provider<ScanNetworks>((ref) {
  final repository = ref.watch(networkSecurityRepositoryProvider);
  return ScanNetworks(repository);
});

final getCurrentNetworkSecurityUseCaseProvider =
    Provider<GetCurrentNetworkSecurity>((ref) {
  final repository = ref.watch(networkSecurityRepositoryProvider);
  return GetCurrentNetworkSecurity(repository);
});

// Data state providers
final scanningNetworksProvider = StateProvider<bool>((ref) => false);

// Networks list state provider
final networksListProvider =
    FutureProvider<List<NetworkSecurityReport>>((ref) async {
  final useCase = ref.watch(scanNetworksUseCaseProvider);
  ref.watch(scanningNetworksProvider.notifier).state = true;

  try {
    final networks = await useCase(const NoParams());
    ref.watch(scanningNetworksProvider.notifier).state = false;
    return networks;
  } catch (e) {
    ref.watch(scanningNetworksProvider.notifier).state = false;
    throw e;
  }
});

// Current network state provider
final currentNetworkProvider =
    FutureProvider<NetworkSecurityReport>((ref) async {
  final useCase = ref.watch(getCurrentNetworkSecurityUseCaseProvider);

  try {
    return await useCase(const NoParams());
  } catch (e) {
    throw e;
  }
});
