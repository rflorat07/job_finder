import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../../../shared/services/bookmarks_service.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../controllers/search_view_model.dart';
import '../widgets/filter_jobs_sheet.dart';

/// Explore screen: live job search with a filter bottom sheet.
///
/// Implements the "Search - Result" design (Frame 41576): a search field,
/// a results subtitle, the job list and a floating "Filter" button.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchViewModel _viewModel;
  late final BookmarksService _bookmarksService;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;
    final datasource = SupabaseSearchRemoteDataSource(client);
    final repository = SearchRepositoryImpl(datasource);

    _bookmarksService = getBookmarksService(client);
    _viewModel = SearchViewModel(repository)..init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final result = await FilterJobsSheet.show(
      context,
      current: _viewModel.filters,
      locations: _viewModel.locations,
    );
    if (result == null || !mounted) return;
    await _viewModel.applyFilters(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('search.explore_title'),
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
        // Only show a back button when this screen was pushed on top of
        // another route (e.g. from Latest Jobs). As the Explore tab root,
        // there is nothing to pop, so the button is hidden.
        leading: context.canPop()
            ? DSCircularIcon.icon(
                IconsaxPlusLinear.arrow_left_1,
                size: SizesTokens.size44,
                iconSize: SizesTokens.size24,
                backgroundColor: context.dsColors.secondaryContainer,
                onPressed: () => context.pop(),
              )
            : null,
        actions: [
          DSCircularIcon.icon(
            IconsaxPlusLinear.more,
            size: SizesTokens.size44,
            iconSize: SizesTokens.size24,
            backgroundColor: context.dsColors.secondaryContainer,
            onPressed: () {
              // TODO: Open contextual menu (sort, saved searches, etc.).
            },
          ),
          const SizedBox(width: SpacingTokens.spacing16),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: DSButton(
        icon: const Icon(IconsaxPlusLinear.filter, size: SizesTokens.size16),
        label: context.tr('search.filter_button'),
        size: DSButtonSize.small,
        onPressed: _openFilters,
      ),
      body: Column(
        children: [
          // ===== Search field =====
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SpacingTokens.spacing24,
              SpacingTokens.spacing8,
              SpacingTokens.spacing24,
              SpacingTokens.spacing16,
            ),
            child: DSSearchField(
              hintText: context.tr('search.search_hint'),
              controller: _searchController,
              icon: IconsaxPlusLinear.search_normal_1,
              onChanged: _viewModel.onQueryChanged,
            ),
          ),

          // ===== Results =====
          Expanded(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return switch (_viewModel.state) {
                  SearchState.loading => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SearchState.error => _SearchError(
                    message: _viewModel.errorMessage,
                    onRetry: _viewModel.refresh,
                  ),
                  SearchState.empty => _SearchEmpty(
                    onRefresh: _viewModel.refresh,
                  ),
                  SearchState.loaded => _SearchResults(
                    viewModel: _viewModel,
                    bookmarksService: _bookmarksService,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loaded State ──────────────────────────────────────────────────────────────

class _SearchResults extends StatefulWidget {
  const _SearchResults({
    required this.viewModel,
    required this.bookmarksService,
  });

  final SearchViewModel viewModel;
  final BookmarksService bookmarksService;

  @override
  State<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<_SearchResults> {
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

  /// Triggers loadMore() when the user scrolls near the bottom (200px).
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
    final viewModel = widget.viewModel;
    final jobs = viewModel.jobs;
    final query = viewModel.filters.query.trim();

    // +1 header (results subtitle) and +1 trailing loader when loading more.
    final hasHeader = query.isNotEmpty;
    final baseCount = jobs.length + (hasHeader ? 1 : 0);
    final itemCount = viewModel.isLoadingMore ? baseCount + 1 : baseCount;

    return RefreshIndicator.adaptive(
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          SpacingTokens.spacing24,
          0,
          SpacingTokens.spacing24,
          // Extra bottom space so the floating Filter button never overlaps
          // the last card.
          SpacingTokens.spacing64,
        ),
        itemCount: itemCount,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SpacingTokens.spacing16),
        itemBuilder: (context, index) {
          // Header: "Search result for "query"."
          if (hasHeader && index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: SpacingTokens.spacing4),
              child: Text(
                context.tr('search.results_for', namedArgs: {'query': query}),
                style: context.dsTextTheme.bodySmall?.copyWith(
                  color: context.dsColors.onSurfaceVariant,
                  fontWeight: TypographyTokens.fontWeightRegular,
                ),
              ),
            );
          }

          final jobIndex = hasHeader ? index - 1 : index;

          // Trailing loader while fetching the next page.
          if (jobIndex >= jobs.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: SpacingTokens.spacing16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          final job = jobs[jobIndex];
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
              isBookmarked: widget.bookmarksService.isBookmarked(job.id),
              onBookmark: () => widget.bookmarksService.toggleBookmark(job.id),
              onTap: () {
                // TODO: Navigate to job details.
              },
            ),
          );
        },
      ),
    );
  }
}

// ─── Error State ───────────────────────────────────────────────────────────────

class _SearchError extends StatelessWidget {
  const _SearchError({required this.message, required this.onRetry});

  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRetry,
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
                          message ?? context.tr('search.generic_error'),
                          textAlign: TextAlign.center,
                          style: context.dsTextTheme.bodyLarge,
                        ),
                        const SizedBox(height: SpacingTokens.spacing16),
                        ElevatedButton(
                          onPressed: onRetry,
                          child: Text(context.tr('search.retry')),
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

class _SearchEmpty extends StatelessWidget {
  const _SearchEmpty({required this.onRefresh});

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
                          context.tr('search.empty_title'),
                          style: context.dsTextTheme.bodyMedium,
                        ),
                        const SizedBox(height: SpacingTokens.spacing8),
                        Text(
                          context.tr('search.empty_subtitle'),
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
