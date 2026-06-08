/// Domain entity for user notifications.
class AppNotificationEntity {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final String? actorName;
  final String? actorAvatarUrl;
  final String? iconEmoji;
  final String? targetRoute;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  const AppNotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.actorName,
    this.actorAvatarUrl,
    this.iconEmoji,
    this.targetRoute,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  AppNotificationEntity copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return AppNotificationEntity(
      id: id,
      userId: userId,
      type: type,
      title: title,
      message: message,
      actorName: actorName,
      actorAvatarUrl: actorAvatarUrl,
      iconEmoji: iconEmoji,
      targetRoute: targetRoute,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }
}
