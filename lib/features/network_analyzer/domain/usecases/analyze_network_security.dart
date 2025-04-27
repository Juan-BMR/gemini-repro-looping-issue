import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/network.dart';
import '../entities/security_level.dart';
import '../repositories/network_repository.dart';
import 'get_networks.dart'; // Import for networkRepositoryProvider

class AnalyzeNetworkSecurity implements UseCase<SecurityLevel, Network> {
  final NetworkRepository _repository;

  AnalyzeNetworkSecurity(this._repository);

  @override
  Future<SecurityLevel> call([Network? network]) async {
    if (network == null) {
      throw ArgumentError('Network parameter cannot be null');
    }

    final analyzedNetwork = await _repository.analyzeNetworkSecurity(network);
    return analyzedNetwork.securityLevel;
  }
}

final analyzeNetworkSecurityProvider = Provider<AnalyzeNetworkSecurity>((ref) {
  final repository = ref.watch(networkRepositoryProvider);
  return AnalyzeNetworkSecurity(repository);
});

// The provider for NetworkRepository is already defined in get_networks.dart
