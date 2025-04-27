import '../../../../core/usecase/usecase.dart';
import '../entities/network_security_report.dart';
import '../repositories/network_security_repository.dart';

class GetCurrentNetworkSecurity
    implements UseCase<NetworkSecurityReport, NoParams> {
  final NetworkSecurityRepository repository;

  GetCurrentNetworkSecurity(this.repository);

  @override
  Future<NetworkSecurityReport> call([NoParams? params]) async {
    final result = await repository.getCurrentNetworkSecurity();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (networkSecurity) => networkSecurity,
    );
  }
}
