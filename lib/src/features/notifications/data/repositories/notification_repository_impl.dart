import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AppNotificationEntity>>> fetchNotifications({
    int limit = 50,
  }) async {
    try {
      final models = await _remoteDataSource.fetchNotifications(limit: limit);
      return Right(models);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to fetch notifications', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update notification', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update notifications', error: e));
    }
  }
}
