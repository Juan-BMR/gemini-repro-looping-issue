import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatMessage>>> getChatHistory();
  Future<Either<Failure, ChatMessage>> sendMessage(String message);
  Future<Either<Failure, void>> clearChatHistory();
  Future<Either<Failure, void>> deleteMessage(ChatMessage message);
}
