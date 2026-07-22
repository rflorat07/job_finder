import '../../domain/entities/conversation_entity.dart';

/// DTO for `conversations` table rows (JSON ↔ Dart).
class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.contactName,
    required super.contactAvatarUrl,
    required super.lastMessage,
    super.lastMessageAt,
    required super.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      contactName: json['contact_name'] as String,
      contactAvatarUrl: json['contact_avatar_url'] as String,
      lastMessage: (json['last_message'] as String?) ?? '',
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      unreadCount: (json['unread_count'] as int?) ?? 0,
    );
  }
}
