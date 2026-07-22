import '../../domain/entities/message_entity.dart';

/// DTO for `messages` table rows (JSON ↔ Dart).
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.body,
    required super.isMine,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      body: json['body'] as String,
      isMine: (json['is_mine'] as bool?) ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
