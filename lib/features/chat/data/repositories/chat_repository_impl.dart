import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;
  final NetworkInfo _networkInfo;

  ChatRepositoryImpl({
    required ApiClient apiClient,
    required NetworkInfo networkInfo,
  })  : _apiClient = apiClient,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatHistory() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await _apiClient.get('/chat/history');
      final List<dynamic> messagesJson = response['messages'];
      final messages =
          messagesJson.map((json) => ChatMessageModel.fromJson(json)).toList();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load chat history'));
    }
  }

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(String message) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await _apiClient.post('/chat/send', {
        'message': message,
      });
      final chatMessage = ChatMessageModel.fromJson(response);
      return Right(chatMessage);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send message'));
    }
  }

  @override
  Future<Either<Failure, void>> clearChatHistory() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await _apiClient.delete('/chat/history');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to clear chat history'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(ChatMessage message) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await _apiClient.delete('/chat/messages/${message.id}');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete message'));
    }
  }
}
