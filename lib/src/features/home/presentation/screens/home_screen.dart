import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../../../shared/services/bookmarks_service.dart';
import '../../../latest_jobs/data/datasources/bookmarks_remote_datasource.dart';
import '../../../latest_jobs/data/repositories/bookmarks_repository_impl.dart';
import '../../../notifications/data/datasources/notifications_remote_datasource.dart';
import '../../../notifications/data/repositories/notification_repository_impl.dart';
import '../../../notifications/presentation/controllers/notifications_view_model.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../controllers/home_view_model.dart';

// ─── Semantic constants ────────────────────────────────────────────────────────
/// Bottom offset of the green background relative to the section edge.
/// Controls how much the carousel cards "overflow" outside the green area.
const double _kGreenOverlapOffset = 68;

/// Height of the horizontal Hot Vacancies carousel.
const double _kCarouselHeight = 160;

/// Height of the Most Recent horizontal carousel cards.
const double _kRecentCarouselHeight = 220;

/// Shared bookmark service singleton — lives as long as the app.
late final BookmarksService bookmarksService;

/// Whether [bookmarksService] has been initialized.
bool _bookmarksServiceInitialized = false;

/// Returns the shared [BookmarksService], creating it on first access.
BookmarksService getBookmarksService(SupabaseClient client) {
  if (!_bookmarksServiceInitialized) {
    final datasource = SupabaseBookmarksRemoteDataSource(client);
    final repository = BookmarksRepositoryImpl(datasource);
    bookmarksService = BookmarksService(repository)..loadBookmarks();
    _bookmarksServiceInitialized = true;
  }
  return bookmarksService;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  late final NotificationsViewModel _notificationsViewModel;
  late final BookmarksService _bookmarksService;
  DateTime _lastNotificationsCheckAt = DateTime.now();

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;
    final datasource = SupabaseHomeRemoteDataSource(client);
    final repository = HomeRepositoryImpl(datasource);
    final notificationsDataSource = SupabaseNotificationsRemoteDataSource(
      client,
    );
    final notificationsRepository = NotificationRepositoryImpl(
      notificationsDataSource,
    );

    _bookmarksService = getBookmarksService(client);
    _viewModel = HomeViewModel(repository)..fetchHomeData();
    _notificationsViewModel = NotificationsViewModel(notificationsRepository)
      ..loadNotifications();
  }

  Future<void> _openNotifications() async {
    _lastNotificationsCheckAt = DateTime.now();
    await context.push(AppRoutes.notifications);
    if (!mounted) return;
    await _notificationsViewModel.loadNotifications();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _notificationsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            HomeState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            HomeState.error => _HomeError(viewModel: _viewModel),
            HomeState.loaded => _HomeContent(
              viewModel: _viewModel,
              bookmarksService: _bookmarksService,
              notificationsViewModel: _notificationsViewModel,
              lastNotificationsCheckAt: _lastNotificationsCheckAt,
              onPressedNotifications: _openNotifications,
            ),
          };
        },
      ),
    );
  }
}

// ─── Error state ───────────────────────────────────────────────────────────────

class _HomeError extends StatelessWidget {
  const _HomeError({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: SizesTokens.size48),
          const SizedBox(height: SpacingTokens.spacing16),
          Text(
            viewModel.errorMessage ?? '',
            style: context.dsTextTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SpacingTokens.spacing16),
          FilledButton(
            onPressed: viewModel.fetchHomeData,
            child: Text(context.tr('home.retry')),
          ),
        ],
      ),
    );
  }
}

// ─── Loaded content ────────────────────────────────────────────────────────────

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.viewModel,
    required this.bookmarksService,
    required this.notificationsViewModel,
    required this.lastNotificationsCheckAt,
    required this.onPressedNotifications,
  });

  final HomeViewModel viewModel;
  final BookmarksService bookmarksService;
  final NotificationsViewModel notificationsViewModel;
  final DateTime lastNotificationsCheckAt;
  final Future<void> Function() onPressedNotifications;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _HomeTopSection(
            viewModel: viewModel,
            notificationsViewModel: notificationsViewModel,
            lastNotificationsCheckAt: lastNotificationsCheckAt,
            onPressedNotifications: onPressedNotifications,
          ),
        ),
        SliverToBoxAdapter(
          child: DSSectionHeader(
            title: context.tr('home.best_matches'),
            actionText: context.tr('home.see_all'),
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.spacing24,
              vertical: SpacingTokens.spacing16,
            ),
            onActionPressed: () {
              context.push(AppRoutes.latestJobs);
            },
          ),
        ),
        _FilterChips(viewModel: viewModel),
        const SliverToBoxAdapter(
          child: SizedBox(height: SpacingTokens.spacing16),
        ),
        _BestMatches(viewModel: viewModel, bookmarksService: bookmarksService),
        SliverToBoxAdapter(
          child: DSSectionHeader(
            title: context.tr('home.most_recent'),
            actionText: context.tr('home.see_all'),
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.spacing24,
              vertical: SpacingTokens.spacing16,
            ),
            onActionPressed: () {
              context.push(AppRoutes.mostRecent);
            },
          ),
        ),
        _MostRecent(viewModel: viewModel, bookmarksService: bookmarksService),
        const SliverToBoxAdapter(
          child: SizedBox(height: SpacingTokens.spacing32),
        ),
      ],
    );
  }
}

// ─── Top section (green background + carousel) ─────────────────────────────────

class _HomeTopSection extends StatelessWidget {
  const _HomeTopSection({
    required this.viewModel,
    required this.notificationsViewModel,
    required this.lastNotificationsCheckAt,
    required this.onPressedNotifications,
  });

  final HomeViewModel viewModel;
  final NotificationsViewModel notificationsViewModel;
  final DateTime lastNotificationsCheckAt;
  final Future<void> Function() onPressedNotifications;

  @override
  Widget build(BuildContext context) {
    final topPadding = context.dsSafeArea.top;

    return Stack(
      children: [
        // Green background — cuts off before the bottom edge so
        // carousel cards visually "overflow" beyond the green area.
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: _kGreenOverlapOffset,
          child: ColoredBox(color: context.dsColors.primary),
        ),

        // Foreground content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topPadding + SpacingTokens.spacing4),
            _HomeHeader(
              notificationsViewModel: notificationsViewModel,
              lastNotificationsCheckAt: lastNotificationsCheckAt,
              onPressedNotifications: onPressedNotifications,
            ),
            const SizedBox(height: SpacingTokens.spacing24),
            const _HomeSearchBar(),
            const SizedBox(height: SpacingTokens.spacing24),
            _HotVacanciesSection(viewModel: viewModel),
          ],
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.notificationsViewModel,
    required this.lastNotificationsCheckAt,
    required this.onPressedNotifications,
  });

  final NotificationsViewModel notificationsViewModel;
  final DateTime lastNotificationsCheckAt;
  final Future<void> Function() onPressedNotifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              spacing: SpacingTokens.spacing4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('home.welcome_back'),
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    height: TypographyTokens.lineHeightExtraRelaxed,
                    fontWeight: TypographyTokens.fontWeightRegular,
                  ),
                ),
                Text(
                  context.tr('home.lets_find_job'),
                  style: context.dsTextTheme.bodyLarge?.copyWith(
                    fontWeight: TypographyTokens.fontWeightBold,
                    color: Colors.white,
                    height: TypographyTokens.lineHeightRelaxed,
                  ),
                ),
              ],
            ),
          ),
          ListenableBuilder(
            listenable: notificationsViewModel,
            builder: (context, _) {
              final bellState = _resolveNotificationBellState(
                notificationsViewModel,
                lastNotificationsCheckAt,
              );

              return _HomeNotificationBell(
                state: bellState,
                onPressed: onPressedNotifications,
              );
            },
          ),
        ],
      ),
    );
  }
}

enum _HomeNotificationBellState { normal, unread, newItems }

class _HomeNotificationBell extends StatelessWidget {
  const _HomeNotificationBell({
    required this.state,
    required this.onPressed,
  });

  final _HomeNotificationBellState state;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final (
      Color iconColor,
      Color backgroundColor,
      Color badgeColor,
      double badgeSize,
    ) = switch (state) {
      _HomeNotificationBellState.normal => (
        Colors.white,
        context.dsColors.surfaceContainer,
        Colors.transparent,
        0,
      ),
      _HomeNotificationBellState.unread => (
        Colors.white,
        context.dsColors.surfaceContainer,
        context.dsColors.error,
        SizesTokens.size6,
      ),
      _HomeNotificationBellState.newItems => (
        Colors.white,
        context.dsColors.surfaceContainer,
        context.dsColors.tertiary,
        SizesTokens.size6,
      ),
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DSCircularIcon.icon(
          IconsaxPlusBold.notification,
          iconColor: iconColor,
          size: SizesTokens.size48,
          iconSize: SizesTokens.size24,
          backgroundColor: backgroundColor,
          onPressed: () {
            onPressed();
          },
        ),
        if (state != _HomeNotificationBellState.normal)
          Positioned(
            top: SpacingTokens.spacing16,
            right: SpacingTokens.spacing16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: RadiusTokens.fullRadius,
              ),
              child: SizedBox(
                width: badgeSize,
                height: badgeSize,
              ),
            ),
          ),
      ],
    );
  }
}

_HomeNotificationBellState _resolveNotificationBellState(
  NotificationsViewModel notificationsViewModel,
  DateTime lastNotificationsCheckAt,
) {
  final hasNewItems = notificationsViewModel.notifications.any(
    (item) => item.createdAt.isAfter(lastNotificationsCheckAt),
  );

  if (hasNewItems) {
    return _HomeNotificationBellState.newItems;
  }

  if (notificationsViewModel.hasUnread) {
    return _HomeNotificationBellState.unread;
  }

  return _HomeNotificationBellState.normal;
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
      ),
      child: DSSearchBar(
        hintText: context.tr('home.search_hint'),
        icon: IconsaxPlusLinear.search_normal_1,
        onTap: () {},
      ),
    );
  }
}

class _HotVacanciesSection extends StatelessWidget {
  const _HotVacanciesSection({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSSectionHeader(
          title: context.tr('home.hot_vacancies'),
          titleColor: Colors.white,
        ),
        const SizedBox(height: SpacingTokens.spacing16),
        SizedBox(
          height: _kCarouselHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.spacing24,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.hotVacancies.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: SpacingTokens.spacing16),
            itemBuilder: (context, index) {
              final vacancy = viewModel.hotVacancies[index];

              return DSHotVacancyCard(
                key: ValueKey(vacancy.id),
                companyName: vacancy.companyName,
                openJobs: context.tr(
                  'home.jobs_open',
                  namedArgs: {'count': '${vacancy.openJobsCount}'},
                ),
                logoUrl: vacancy.logoUrl,
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BestMatches extends StatelessWidget {
  const _BestMatches({
    required this.viewModel,
    required this.bookmarksService,
  });

  final HomeViewModel viewModel;
  final BookmarksService bookmarksService;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
      ),
      sliver: SliverList.separated(
        itemCount: viewModel.bestMatches.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SpacingTokens.spacing16),
        itemBuilder: (context, index) {
          final job = viewModel.bestMatches[index];
          return ListenableBuilder(
            listenable: bookmarksService,
            builder: (context, _) => DSJobCard(
              key: ValueKey(job.id),
              jobTitle: job.jobTitle,
              companyName: job.companyName,
              location: job.location,
              salary: job.salary,
              logoUrl: job.companyLogoUrl,
              tags: job.tags,
              timeAgo: _formatTimeAgo(context, job.postedAt),
              isBookmarked: bookmarksService.isBookmarked(job.id),
              onBookmark: () => bookmarksService.toggleBookmark(job.id),
              onTap: () => context.push(
                AppRoutes.jobDetail,
                extra: JobDetailArgs(id: job.id, initialJob: job),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    const filters = JobFilter.values;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: SizesTokens.size38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          itemCount: filters.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: SpacingTokens.spacing12),
          itemBuilder: (context, index) {
            final filter = filters[index];
            return DSFilterChip(
              showBorder: false,
              label: _filterLabel(context, filter),
              isSelected: viewModel.selectedFilter == filter,
              onSelected: (_) => viewModel.setFilter(filter),
            );
          },
        ),
      ),
    );
  }
}

class _MostRecent extends StatelessWidget {
  const _MostRecent({
    required this.viewModel,
    required this.bookmarksService,
  });

  final HomeViewModel viewModel;
  final BookmarksService bookmarksService;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _kRecentCarouselHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          itemCount: viewModel.recentJobs.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: SpacingTokens.spacing16),
          itemBuilder: (context, index) {
            final job = viewModel.recentJobs[index];
            return ListenableBuilder(
              listenable: bookmarksService,
              builder: (context, _) => DSRecentJobCard(
                key: ValueKey(job.id),
                jobTitle: job.jobTitle,
                companyName: job.companyName,
                location: job.location,
                salary: job.salary,
                description: job.description ?? '',
                logoUrl: job.companyLogoUrl,
                tags: job.tags,
                isBookmarked: bookmarksService.isBookmarked(job.id),
                onBookmark: () => bookmarksService.toggleBookmark(job.id),
                onTap: () => context.push(
                  AppRoutes.jobDetail,
                  extra: JobDetailArgs(id: job.id, initialJob: job),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Formats a [DateTime] into a relative time string using translations.
String _formatTimeAgo(BuildContext context, DateTime postedAt) {
  final difference = DateTime.now().difference(postedAt);

  if (difference.inDays == 0) {
    return context.tr('home.posted_today');
  }
  return context.tr(
    'home.days_ago',
    namedArgs: {'count': '${difference.inDays}'},
  );
}

/// Returns the localized label for a given [JobFilter].
String _filterLabel(BuildContext context, JobFilter filter) {
  return switch (filter) {
    JobFilter.allJobs => context.tr('home.filter_all_jobs'),
    JobFilter.fullTime => context.tr('home.filter_full_time'),
    JobFilter.partTime => context.tr('home.filter_part_time'),
    JobFilter.freelance => context.tr('home.filter_freelance'),
  };
}
