import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/network_traffic.dart';
import '../repositories/network_traffic_repository.dart';

class GetAppDataUsage
    implements UseCase<List<AppDataUsageStats>, DateRangeParams> {
  final NetworkTrafficRepository repository;

  GetAppDataUsage(this.repository);

  @override
  Future<List<AppDataUsageStats>> call([DateRangeParams? params]) async {
    if (params == null) {
      throw ArgumentError('DateRangeParams cannot be null');
    }

    final result = await repository.getAppDataUsage(
      startTime: params.startTime,
      endTime: params.endTime,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (stats) => stats,
    );
  }
}

class DateRangeParams extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  const DateRangeParams({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}
