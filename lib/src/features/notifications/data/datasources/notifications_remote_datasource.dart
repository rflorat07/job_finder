import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<AppNotificationModel>> fetchNotifications({int limit = 50});

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();
}

class SupabaseNotificationsRemoteDataSource
    implements NotificationsRemoteDataSource {
  final SupabaseClient _client;

  SupabaseNotificationsRemoteDataSource(this._client);

  String _currentUserId() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('No authenticated user found.');
    }
    return user.id;
  }

  @override
  Future<List<AppNotificationModel>> fetchNotifications({
    int limit = 50,
  }) async {
    final userId = _currentUserId();

    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return response.map((json) => AppNotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final userId = _currentUserId();

    await _client
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', notificationId)
        .eq('user_id', userId);
  }

  @override
  Future<void> markAllAsRead() async {
    final userId = _currentUserId();

    await _client
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('is_read', false);
  }
}
