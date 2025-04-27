import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/network_security_report.dart';
import '../../domain/repositories/network_security_repository.dart';
import '../datasources/network_security_datasource.dart';

class NetworkSecurityRepositoryImpl implements NetworkSecurityRepository {
  final NetworkSecurityDataSource dataSource;
  final NetworkInfo networkInfo;

  NetworkSecurityRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> canPerformNetworkScanning() async {
    try {
      final canScan = await dataSource.canPerformNetworkScanning();
      return Right(canScan);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NetworkSecurityReport>>
      getCurrentNetworkSecurity() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final networkSecurity = await dataSource.getCurrentNetworkSecurity();
      return Right(networkSecurity);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NetworkSecurityReport>>> scanNetworks() async {
    try {
      // First request permissions if needed
      final hasPermissions = await dataSource.requestScanningPermissions();
      if (!hasPermissions) {
        return Left(
            ServerFailure(message: 'Permission denied for network scanning'));
      }

      final networks = await dataSource.scanNetworks();
      return Right(networks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
