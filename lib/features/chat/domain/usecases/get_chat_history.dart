import '../../../../core/usecase/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatHistory implements UseCase<List<ChatMessage>, NoParams> {
  final ChatRepository repository;

  GetChatHistory(this.repository);

  @override
  Future<List<ChatMessage>> call([NoParams? params]) async {
    final result = await repository.getChatHistory();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (messages) => messages,
    );
  }
}
