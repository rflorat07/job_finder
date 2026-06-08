import '../../domain/entities/app_notification_entity.dart';

/// DTO for notifications table rows.
class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.message,
    super.actorName,
    super.actorAvatarUrl,
    super.iconEmoji,
    super.targetRoute,
    required super.isRead,
    super.readAt,
    required super.createdAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: (json['type'] as String?) ?? 'general',
      title: json['title'] as String,
      message: json['message'] as String,
      actorName: json['actor_name'] as String?,
      actorAvatarUrl: json['actor_avatar_url'] as String?,
      iconEmoji: json['icon_emoji'] as String?,
      targetRoute: json['target_route'] as String?,
      isRead: (json['is_read'] as bool?) ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
