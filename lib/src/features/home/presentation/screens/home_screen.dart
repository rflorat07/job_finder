import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/home_view_model.dart';

// ─── Semantic constants ────────────────────────────────────────────────────────
/// Bottom offset of the green background relative to the section edge.
/// Controls how much the carousel cards "overflow" outside the green area.
const double _kGreenOverlapOffset = 68;

/// Height of the horizontal Hot Vacancies carousel.
const double _kCarouselHeight = 160;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel()..fetchHomeData();
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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            HomeState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            HomeState.error => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: SizesTokens.size48),
                  const SizedBox(height: SpacingTokens.spacing16),
                  Text(
                    _viewModel.errorMessage ?? '',
                    style: context.dsTextTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: SpacingTokens.spacing16),
                  FilledButton(
                    onPressed: _viewModel.fetchHomeData,
                    child: Text(context.tr('home.retry')),
                  ),
                ],
              ),
            ),
            HomeState.loaded => CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                // ===== Top section with green background and carousel =====
                SliverToBoxAdapter(
                  child: _HomeTopSection(viewModel: _viewModel),
                ),

                // ===== Best Matches section header =====
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.spacing24,
                    vertical: SpacingTokens.spacing16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: DSSectionHeader(
                      title: context.tr('home.best_matches'),
                      actionText: context.tr('home.see_all'),
                      onActionPressed: () {
                        // TODO: Navigate to full Best Matches list
                      },
                    ),
                  ),
                ),

                // ===== Filter chips =====
                _FilterChips(viewModel: _viewModel),

                // Spacing between chips and job cards
                const SliverToBoxAdapter(
                  child: SizedBox(height: SpacingTokens.spacing16),
                ),

                // ===== Best Matches job cards =====
                _BestMatches(viewModel: _viewModel),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: SpacingTokens.spacing32),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _HomeTopSection extends StatelessWidget {
  final HomeViewModel viewModel;

  const _HomeTopSection({required this.viewModel});

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
            // SizedBox for top padding + extra spacing from the green background edge
            SizedBox(height: topPadding + SpacingTokens.spacing4),

            // =====  Main title & Notification bell =====
            Padding(
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

                  DSCircularIcon.icon(
                    IconsaxPlusBold.notification,
                    iconColor: Colors.white,
                    size: SizesTokens.size48,
                    iconSize: SizesTokens.size24,
                    backgroundColor: context.dsColors.surfaceContainer,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: SpacingTokens.spacing24),

            // ===== Search Bar (Faux — navigates to SearchScreen) =====
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: DSSearchBar(
                hintText: context.tr('home.search_hint'),
                icon: IconsaxPlusLinear.search_normal_1,
                onTap: () {},
              ),
            ),

            const SizedBox(height: SpacingTokens.spacing24),

            // ===== "Hot Vacancies" header =====
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: Text(
                context.tr('home.hot_vacancies'),
                style: context.dsTextTheme.titleMedium?.copyWith(
                  fontWeight: TypographyTokens.fontWeightBold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.spacing16),

            // ===== Horizontal Carousel =====
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
        ),
      ],
    );
  }
}

class _BestMatches extends StatelessWidget {
  const _BestMatches({required HomeViewModel viewModel})
    : _viewModel = viewModel;

  final HomeViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing24,
      ),
      sliver: SliverList.separated(
        itemCount: _viewModel.bestMatches.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: SpacingTokens.spacing16),
        itemBuilder: (context, index) {
          final job = _viewModel.bestMatches[index];
          return DSJobCard(
            jobTitle: job.jobTitle,
            companyName: job.companyName,
            location: job.location,
            salary: job.salary,
            logoUrl: job.companyLogoUrl,
            tags: job.tags,
            timeAgo: _formatTimeAgo(context, job.postedAt),
            onBookmark: () {},
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required HomeViewModel viewModel})
    : _viewModel = viewModel;

  final HomeViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: SizesTokens.size38,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          children: JobFilter.values.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(
                right: SpacingTokens.spacing12,
              ),
              child: DSFilterChip(
                showBorder: false,
                label: _filterLabel(context, filter),
                isSelected: _viewModel.selectedFilter == filter,
                onSelected: (_) => _viewModel.setFilter(filter),
              ),
            );
          }).toList(),
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
