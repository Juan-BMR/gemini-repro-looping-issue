import '../../../../core/usecase/usecase.dart';
import '../entities/network_security_report.dart';
import '../repositories/network_security_repository.dart';

class ScanNetworks implements UseCase<List<NetworkSecurityReport>, NoParams> {
  final NetworkSecurityRepository repository;

  ScanNetworks(this.repository);

  @override
  Future<List<NetworkSecurityReport>> call([NoParams? params]) async {
    final result = await repository.scanNetworks();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (networks) => networks,
    );
  }
}
