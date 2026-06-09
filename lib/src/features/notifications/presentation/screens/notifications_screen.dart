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

  Future<void> _onRefresh() {
    return _viewModel.loadNotifications();
  }

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
            NotificationsState.error => _RefreshableBody(
              onRefresh: _onRefresh,
              child: _NotificationsError(
                message: _viewModel.errorMessage,
                onRetry: _viewModel.loadNotifications,
              ),
            ),
            NotificationsState.empty => _RefreshableBody(
              onRefresh: _onRefresh,
              child: const _NotificationsEmpty(),
            ),
            NotificationsState.loaded => _NotificationsLoaded(
              viewModel: _viewModel,
              onRefresh: _onRefresh,
            ),
          };
        },
      ),
    );
  }
}

class _RefreshableBody extends StatelessWidget {
  const _RefreshableBody({
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(child: child),
              ),
            ],
          );
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
              style: context.dsTextTheme.bodyMedium,
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
  const _NotificationsLoaded({
    required this.viewModel,
    required this.onRefresh,
  });

  final NotificationsViewModel viewModel;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          SpacingTokens.spacing24,
          SpacingTokens.spacing16,
          SpacingTokens.spacing24,
          SpacingTokens.spacing32,
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
      ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.dsTextTheme.bodyMedium?.copyWith(
            color: context.dsColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: SpacingTokens.spacing16),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return DSNotificationCard(
              title: item.title,
              description: item.message,
              timeLabel: _formatTime(context, item.createdAt),
              avatarUrl: item.actorAvatarUrl,
              fallbackEmoji: item.iconEmoji ?? '🔔',
              isRead: item.isRead,
              onTap: () => onTapNotification(item.id),
            );
          },
        ),
      ],
    );
  }
}

String _formatTime(BuildContext context, DateTime value) {
  final local = value.toLocal();
  final time = TimeOfDay.fromDateTime(local);
  return time.format(context);
}
