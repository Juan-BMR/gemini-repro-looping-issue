import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isUser;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUser,
  });

  @override
  List<Object> get props => [id, content, timestamp, isUser];
}
