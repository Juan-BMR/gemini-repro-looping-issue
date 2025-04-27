import '../../../../core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class ClearChatHistory implements UseCase<void, NoParams> {
  final ChatRepository repository;

  ClearChatHistory(this.repository);

  @override
  Future<void> call([NoParams? params]) async {
    final result = await repository.clearChatHistory();
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) => null,
    );
  }
}
