import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../controllers/notifications_view_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final datasource = SupabaseNotificationsRemoteDataSource(client);
    final repository = NotificationRepositoryImpl(datasource);
    _viewModel = NotificationsViewModel(repository);
    _viewModel.loadNotifications();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('notifications.title'),
        backgroundColor: context.dsColors.primaryContainer,
        leading: DSCircularIcon.icon(
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          IconsaxPlusLinear.arrow_left_1,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            NotificationsState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            NotificationsState.error => _NotificationsError(
              message: _viewModel.errorMessage,
              onRetry: _viewModel.loadNotifications,
            ),
            NotificationsState.empty => const _NotificationsEmpty(),
            NotificationsState.loaded => _NotificationsLoaded(
              viewModel: _viewModel,
            ),
          };
        },
      ),
    );
  }
}

class _NotificationsError extends StatelessWidget {
  const _NotificationsError({
    required this.message,
    required this.onRetry,
  });

  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? context.tr('notifications.generic_error'),
              textAlign: TextAlign.center,
              style: context.dsTextTheme.bodyLarge,
            ),
            const SizedBox(height: SpacingTokens.spacing16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.tr('home.retry')),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsEmpty extends StatelessWidget {
  const _NotificationsEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.spacing24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusLinear.notification,
              size: SizesTokens.size48,
              color: context.dsColors.onSurfaceVariant,
            ),
            const SizedBox(height: SpacingTokens.spacing12),
            Text(
              context.tr('notifications.empty_title'),
              style: context.dsTextTheme.titleMedium,
            ),
            const SizedBox(height: SpacingTokens.spacing8),
            Text(
              context.tr('notifications.empty_subtitle'),
              textAlign: TextAlign.center,
              style: context.dsTextTheme.bodyMedium?.copyWith(
                color: context.dsColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsLoaded extends StatelessWidget {
  const _NotificationsLoaded({required this.viewModel});

  final NotificationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.spacing24,
        SpacingTokens.spacing16,
        SpacingTokens.spacing24,
        SpacingTokens.spacing24,
      ),
      children: [
        _NotificationsSection(
          title: context.tr('notifications.today'),
          notifications: viewModel.todayNotifications,
          onTapNotification: viewModel.markAsRead,
        ),
        _NotificationsSection(
          title: context.tr('notifications.yesterday'),
          notifications: viewModel.yesterdayNotifications,
          onTapNotification: viewModel.markAsRead,
        ),
        _NotificationsSection(
          title: context.tr('notifications.older'),
          notifications: viewModel.olderNotifications,
          onTapNotification: viewModel.markAsRead,
        ),
      ],
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({
    required this.title,
    required this.notifications,
    required this.onTapNotification,
  });

  final String title;
  final List<AppNotificationEntity> notifications;
  final Future<void> Function(String notificationId) onTapNotification;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.dsTextTheme.titleLarge?.copyWith(
              color: context.dsColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SpacingTokens.spacing12),
          ...notifications.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.spacing12),
              child: _NotificationCard(
                item: item,
                onTap: () => onTapNotification(item.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onTap,
  });

  final AppNotificationEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = context.dsColors.primaryContainer;
    final borderColor = item.isRead
        ? Colors.transparent
        : context.dsColors.primary.withAlpha(75);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(SpacingTokens.spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NotificationAvatar(item: item),
                const SizedBox(width: SpacingTokens.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.dsTextTheme.titleMedium?.copyWith(
                                fontWeight: TypographyTokens.fontWeightBold,
                              ),
                            ),
                          ),
                          const SizedBox(width: SpacingTokens.spacing8),
                          Text(
                            _formatTime(context, item.createdAt),
                            style: context.dsTextTheme.bodyMedium?.copyWith(
                              color: context.dsColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SpacingTokens.spacing8),
                      Text(
                        item.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.dsTextTheme.bodyLarge?.copyWith(
                          color: context.dsColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  const _NotificationAvatar({required this.item});

  final AppNotificationEntity item;

  @override
  Widget build(BuildContext context) {
    if (item.actorAvatarUrl != null && item.actorAvatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: SizesTokens.size24,
        backgroundImage: NetworkImage(item.actorAvatarUrl!),
      );
    }

    return CircleAvatar(
      radius: SizesTokens.size24,
      backgroundColor: context.dsColors.tertiaryContainer,
      child: Text(
        item.iconEmoji ?? '🔔',
        style: context.dsTextTheme.titleMedium,
      ),
    );
  }
}

String _formatTime(BuildContext context, DateTime value) {
  final local = value.toLocal();
  final time = TimeOfDay.fromDateTime(local);
  return time.format(context);
}
