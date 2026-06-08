import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
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

    final datasource = SupabaseHomeRemoteDataSource(
      Supabase.instance.client,
    );
    final repository = HomeRepositoryImpl(datasource);

    _viewModel = HomeViewModel(repository)..fetchHomeData();
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
            HomeState.error => _HomeError(viewModel: _viewModel),
            HomeState.loaded => _HomeContent(viewModel: _viewModel),
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
  const _HomeContent({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _HomeTopSection(viewModel: viewModel),
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
              // TODO: Navigate to full Best Matches list
            },
          ),
        ),
        _FilterChips(viewModel: viewModel),
        const SliverToBoxAdapter(
          child: SizedBox(height: SpacingTokens.spacing16),
        ),
        _BestMatches(viewModel: viewModel),
        SliverToBoxAdapter(
          child: DSSectionHeader(
            title: context.tr('home.most_recent'),
            actionText: context.tr('home.see_all'),
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.spacing24,
              vertical: SpacingTokens.spacing16,
            ),
            onActionPressed: () {
              // TODO: Navigate to full Most Recent list
            },
          ),
        ),
        _MostRecent(viewModel: viewModel),
        const SliverToBoxAdapter(
          child: SizedBox(height: SpacingTokens.spacing32),
        ),
      ],
    );
  }
}

// ─── Top section (green background + carousel) ─────────────────────────────────

class _HomeTopSection extends StatelessWidget {
  const _HomeTopSection({required this.viewModel});

  final HomeViewModel viewModel;

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
            const _HomeHeader(),
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
  const _HomeHeader();

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
          DSCircularIcon.icon(
            IconsaxPlusBold.notification,
            iconColor: Colors.white,
            size: SizesTokens.size48,
            iconSize: SizesTokens.size24,
            backgroundColor: context.dsColors.surfaceContainer,
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }
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
  const _BestMatches({required this.viewModel});

  final HomeViewModel viewModel;

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
          return DSJobCard(
            key: ValueKey(job.id),
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
  const _MostRecent({required this.viewModel});

  final HomeViewModel viewModel;

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
            return DSRecentJobCard(
              key: ValueKey(job.id),
              jobTitle: job.jobTitle,
              companyName: job.companyName,
              location: job.location,
              salary: job.salary,
              description: job.description ?? '',
              logoUrl: job.companyLogoUrl,
              tags: job.tags,
              onBookmark: () {},
              onTap: () {},
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
