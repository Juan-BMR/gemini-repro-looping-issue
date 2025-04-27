import '../../../../core/usecase/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class DeleteMessage implements UseCase<void, ChatMessage> {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  @override
  Future<void> call([ChatMessage? message]) async {
    if (message == null) {
      throw ArgumentError('ChatMessage cannot be null');
    }
    await repository.deleteMessage(message);
  }
}
