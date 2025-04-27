import '../../../../core/usecase/usecase.dart';
import '../entities/network_traffic.dart';
import '../repositories/network_traffic_repository.dart';

class MonitorNetworkTraffic
    implements StreamUseCase<ConnectionEvent, NoParams> {
  final NetworkTrafficRepository repository;

  MonitorNetworkTraffic(this.repository);

  @override
  Stream<ConnectionEvent> call([NoParams? params]) {
    final result = repository.monitorNetworkTraffic();
    return result.fold(
      (failure) => Stream.error(Exception(failure.message)),
      (stream) => stream,
    );
  }
}

/// StreamUseCase is a special type of UseCase that returns a Stream
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call([Params params]);
}
