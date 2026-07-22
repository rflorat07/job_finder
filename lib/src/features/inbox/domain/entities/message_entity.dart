/// Domain entity for a single chat message inside a conversation.
class MessageEntity {
  final String id;
  final String conversationId;
  final String body;
  final bool isMine;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.body,
    required this.isMine,
    required this.createdAt,
  });
}
