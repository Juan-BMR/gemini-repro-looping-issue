import '../../../../core/usecase/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<ChatMessage, String> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<ChatMessage> call([String? message]) async {
    if (message == null || message.isEmpty) {
      throw ArgumentError('Message cannot be null or empty');
    }

    final result = await repository.sendMessage(message);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (chatMessage) => chatMessage,
    );
  }
}
