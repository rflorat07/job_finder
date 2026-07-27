import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../../../shared/services/bookmarks_service.dart';
import '../../../latest_jobs/data/datasources/latest_jobs_remote_datasource.dart';
import '../../../latest_jobs/data/repositories/latest_jobs_repository_impl.dart';
import '../controllers/trending_jobs_view_model.dart';

class TrendingJobsScreen extends StatefulWidget {
  const TrendingJobsScreen({super.key});

  @override
  State<TrendingJobsScreen> createState() => _TrendingJobsScreenState();
}

class _TrendingJobsScreenState extends State<TrendingJobsScreen> {
  late final TrendingJobsViewModel _viewModel;
  late final BookmarksService _bookmarksService;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;
    final datasource = SupabaseLatestJobsRemoteDataSource(client);
    final repository = LatestJobsRepositoryImpl(datasource);

    _bookmarksService = getBookmarksService(client);
    _viewModel = TrendingJobsViewModel(repository)..loadJobs();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() => _viewModel.refresh();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('trending_jobs.title'),
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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            TrendingJobsState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            TrendingJobsState.error => _TrendingJobsError(
              message: _viewModel.errorMessage,
              onRetry: _viewModel.loadJobs,
              onRefresh: _onRefresh,
            ),
            TrendingJobsState.empty => _TrendingJobsEmpty(
              onRefresh: _onRefresh,
            ),
            TrendingJobsState.loaded => _TrendingJobsLoaded(
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

class _TrendingJobsLoaded extends StatefulWidget {
  const _TrendingJobsLoaded({
    required this.viewModel,
    required this.bookmarksService,
    required this.onRefresh,
  });

  final TrendingJobsViewModel viewModel;
  final BookmarksService bookmarksService;
  final Future<void> Function() onRefresh;

  @override
  State<_TrendingJobsLoaded> createState() => _TrendingJobsLoadedState();
}

class _TrendingJobsLoadedState extends State<_TrendingJobsLoaded> {
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
          if (index >= jobs.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: SpacingTokens.spacing16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          final job = jobs[index];
          return ListenableBuilder(
            listenable: widget.bookmarksService,
            builder: (context, _) => DSRecentJobCard(
              key: ValueKey(job.id),
              width: double.infinity,
              jobTitle: job.jobTitle,
              companyName: job.companyName,
              location: job.location,
              salary: job.salary,
              description: job.description ?? '',
              logoUrl: job.companyLogoUrl,
              tags: job.tags,
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
}

// ─── Error State ───────────────────────────────────────────────────────────────

class _TrendingJobsError extends StatelessWidget {
  const _TrendingJobsError({
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.spacing24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: SizesTokens.size48,
                        ),
                        const SizedBox(height: SpacingTokens.spacing16),
                        Text(
                          message ?? context.tr('trending_jobs.generic_error'),
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

class _TrendingJobsEmpty extends StatelessWidget {
  const _TrendingJobsEmpty({required this.onRefresh});

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
                          IconsaxPlusLinear.briefcase,
                          size: SizesTokens.size48,
                          color: context.dsColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: SpacingTokens.spacing12),
                        Text(
                          context.tr('trending_jobs.empty_title'),
                          style: context.dsTextTheme.bodyMedium,
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
