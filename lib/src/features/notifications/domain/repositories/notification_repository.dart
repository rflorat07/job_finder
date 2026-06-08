import '../../../../utils/typedefs.dart';
import '../entities/app_notification_entity.dart';

abstract class NotificationRepository {
  FutureEither<List<AppNotificationEntity>> fetchNotifications({
    int limit = 50,
  });

  FutureEitherVoid markAsRead(String notificationId);

  FutureEitherVoid markAllAsRead();
}
