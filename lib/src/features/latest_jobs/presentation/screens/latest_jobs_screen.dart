import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../../../shared/services/bookmarks_service.dart';
import '../../data/datasources/latest_jobs_remote_datasource.dart';
import '../../data/repositories/latest_jobs_repository_impl.dart';
import '../controllers/latest_jobs_view_model.dart';

class LatestJobsScreen extends StatefulWidget {
  const LatestJobsScreen({super.key});

  @override
  State<LatestJobsScreen> createState() => _LatestJobsScreenState();
}

class _LatestJobsScreenState extends State<LatestJobsScreen> {
  late final LatestJobsViewModel _viewModel;
  late final BookmarksService _bookmarksService;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;
    final jobsDatasource = SupabaseLatestJobsRemoteDataSource(client);
    final jobsRepository = LatestJobsRepositoryImpl(jobsDatasource);

    _bookmarksService = getBookmarksService(client);
    _viewModel = LatestJobsViewModel(jobsRepository)..loadJobs();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    return _viewModel.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('latest_jobs.latest_jobs_title'),
        backgroundColor: context.dsColors.primaryContainer,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.pop(),
        ),
        actions: [
          DSCircularIcon.icon(
            IconsaxPlusLinear.search_normal_1,
            size: SizesTokens.size44,
            iconSize: SizesTokens.size24,
            backgroundColor: context.dsColors.secondaryContainer,
            onPressed: () => context.push(AppRoutes.explore),
          ),
          const SizedBox(width: SpacingTokens.spacing16),
        ],
        centerTitle: true,
      ),
      // Listen to ViewModel state changes
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            LatestJobsState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            LatestJobsState.error => _LatestJobsError(
              message: _viewModel.errorMessage,
              onRetry: _viewModel.loadJobs,
              onRefresh: _onRefresh,
            ),
            LatestJobsState.empty => _LatestJobsEmpty(onRefresh: _onRefresh),
            LatestJobsState.loaded => _LatestJobsLoaded(
              viewModel: _viewModel,
              bookmarksService: _bookmarksService,
              onRefresh: _onRefresh,
            ),
          };
        },
      ),
    );
  }
}

// ─── Loaded State ──────────────────────────────────────────────────────────────

class _LatestJobsLoaded extends StatefulWidget {
  const _LatestJobsLoaded({
    required this.viewModel,
    required this.bookmarksService,
    required this.onRefresh,
  });

  final LatestJobsViewModel viewModel;
  final BookmarksService bookmarksService;
  final Future<void> Function() onRefresh;

  @override
  State<_LatestJobsLoaded> createState() => _LatestJobsLoadedState();
}

class _LatestJobsLoadedState extends State<_LatestJobsLoaded> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Triggers loadMore() when user scrolls near the bottom (200px threshold).
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (currentScroll >= maxScroll - threshold) {
      widget.viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobs = widget.viewModel.jobs;
    // +1 for the loading indicator at the bottom when loading more
    final itemCount = widget.viewModel.isLoadingMore
        ? jobs.length + 1
        : jobs.length;

    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(SpacingTokens.spacing24),
        itemCount: itemCount,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SpacingTokens.spacing16),
        itemBuilder: (context, index) {
          // Loading indicator at the bottom
          if (index >= jobs.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: SpacingTokens.spacing16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          final job = jobs[index];
          return ListenableBuilder(
            listenable: widget.bookmarksService,
            builder: (context, _) => DSJobCard(
              key: ValueKey(job.id),
              jobTitle: job.jobTitle,
              companyName: job.companyName,
              location: job.location,
              salary: job.salary,
              logoUrl: job.companyLogoUrl,
              tags: job.tags,
              timeAgo: _formatTimeAgo(context, job.postedAt),
              isBookmarked: widget.bookmarksService.isBookmarked(job.id),
              onBookmark: () => widget.bookmarksService.toggleBookmark(job.id),
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

  /// Formats a [DateTime] into a relative time string using translations.
  String _formatTimeAgo(BuildContext context, DateTime postedAt) {
    final difference = DateTime.now().difference(postedAt);

    if (difference.inDays == 0) {
      return context.tr('latest_jobs.posted_today');
    }
    return context.tr(
      'latest_jobs.days_ago',
      namedArgs: {'count': '${difference.inDays}'},
    );
  }
}

// ─── Error State ───────────────────────────────────────────────────────────────

class _LatestJobsError extends StatelessWidget {
  const _LatestJobsError({
    required this.message,
    required this.onRetry,
    required this.onRefresh,
  });

  final String? message;
  final Future<void> Function() onRetry;
  final Future<void> Function() onRefresh;

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
                child: DSErrorState(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.spacing24,
                  ),
                  message: message ?? context.tr('latest_jobs.generic_error'),
                  retryLabel: context.tr('home.retry'),
                  onRetry: onRetry,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────────────────────

class _LatestJobsEmpty extends StatelessWidget {
  const _LatestJobsEmpty({required this.onRefresh});

  final Future<void> Function() onRefresh;

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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.spacing24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconsaxPlusLinear.search_normal_1,
                          size: SizesTokens.size48,
                          color: context.dsColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: SpacingTokens.spacing12),
                        Text(
                          context.tr('latest_jobs.empty_title'),
                          style: context.dsTextTheme.bodyMedium,
                        ),
                        const SizedBox(height: SpacingTokens.spacing8),
                        Text(
                          context.tr('latest_jobs.empty_subtitle'),
                          textAlign: TextAlign.center,
                          style: context.dsTextTheme.bodyMedium?.copyWith(
                            color: context.dsColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
