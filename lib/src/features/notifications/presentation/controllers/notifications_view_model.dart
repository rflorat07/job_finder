import 'package:flutter/material.dart';

import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

enum NotificationsState { loading, loaded, empty, error }

class NotificationsViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationsViewModel(this._repository);

  NotificationsState _state = NotificationsState.loading;
  String? _errorMessage;
  List<AppNotificationEntity> _notifications = [];

  NotificationsState get state => _state;
  String? get errorMessage => _errorMessage;
  List<AppNotificationEntity> get notifications =>
      List.unmodifiable(_notifications);

  List<AppNotificationEntity> get todayNotifications {
    final now = DateTime.now();
    return _notifications
        .where((item) {
          return _isSameDate(item.createdAt, now);
        })
        .toList(growable: false);
  }

  List<AppNotificationEntity> get yesterdayNotifications {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _notifications
        .where((item) {
          return _isSameDate(item.createdAt, yesterday);
        })
        .toList(growable: false);
  }

  List<AppNotificationEntity> get olderNotifications {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return _notifications
        .where((item) {
          final createdAt = item.createdAt;
          return !_isSameDate(createdAt, now) &&
              !_isSameDate(createdAt, yesterday);
        })
        .toList(growable: false);
  }

  bool get hasUnread => _notifications.any((item) => !item.isRead);

  Future<void> loadNotifications() async {
    _state = NotificationsState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchNotifications();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = NotificationsState.error;
      },
      (items) {
        _notifications = items;
        _state = items.isEmpty
            ? NotificationsState.empty
            : NotificationsState.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere(
      (item) => item.id == notificationId,
    );
    if (index == -1) return;

    final current = _notifications[index];
    if (current.isRead) return;

    final updated = current.copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
    _notifications = [..._notifications]..[index] = updated;
    notifyListeners();

    final result = await _repository.markAsRead(notificationId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {},
    );
  }

  Future<void> markAllAsRead() async {
    if (!hasUnread) return;

    final now = DateTime.now();
    _notifications = _notifications
        .map((item) => item.copyWith(isRead: true, readAt: now))
        .toList(growable: false);
    notifyListeners();

    final result = await _repository.markAllAsRead();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {},
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
