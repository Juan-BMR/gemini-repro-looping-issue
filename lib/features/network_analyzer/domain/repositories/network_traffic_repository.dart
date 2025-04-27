import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/network_traffic.dart';

abstract class NetworkTrafficRepository {
  /// Get active network connections
  Future<Either<Failure, List<ConnectionEvent>>> getActiveConnections();

  /// Get data usage statistics by app for a specific time period
  Future<Either<Failure, List<AppDataUsageStats>>> getAppDataUsage({
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Analyze app privacy concerns
  Future<Either<Failure, List<PrivacyConcern>>> getAppPrivacyConcerns();

  /// Check if a domain is potentially malicious
  Future<Either<Failure, bool>> isDomainMalicious(String domain);

  /// Get connection history
  Future<Either<Failure, List<ConnectionEvent>>> getConnectionHistory({
    required DateTime startTime,
    required DateTime endTime,
    int? limit,
  });

  /// Start monitoring network traffic (returns stream of connection events)
  Either<Failure, Stream<ConnectionEvent>> monitorNetworkTraffic();

  /// Check if app has necessary permissions for traffic monitoring
  Future<Either<Failure, bool>> canMonitorTraffic();
}
