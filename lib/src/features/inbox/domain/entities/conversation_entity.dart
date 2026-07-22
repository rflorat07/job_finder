/// Domain entity for an inbox conversation (a chat thread with a contact).
class ConversationEntity {
  final String id;
  final String contactName;
  final String contactAvatarUrl;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ConversationEntity({
    required this.id,
    required this.contactName,
    required this.contactAvatarUrl,
    required this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
  });
}
