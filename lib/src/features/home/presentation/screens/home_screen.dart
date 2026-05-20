import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../controllers/home_view_model.dart';

// ─── Semantic constants ────────────────────────────────────────────────────────
/// Bottom offset of the green background relative to the section edge.
/// Controls how much the carousel cards "overflow" outside the green area.
const double _kGreenOverlapOffset = 90;

/// Height of the horizontal Hot Vacancies carousel.
const double _kCarouselHeight = 160;

/// Placeholder/hint color in the search bar (neutral grey).
const Color _kHintColor = Color(0xFF818898);

/// Scaffold background color (off-white).
const Color _kScaffoldBg = Color(0xFFF6F8FA);

/// Background color for network icon in card (light grey).
const Color _kNetworkIconBg = Color(0xFFF3F4F6);

/// Background color for SVG icon in card (light green).
const Color _kSvgIconBg = Color(0xFFE5F1E5);

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
      backgroundColor: _kScaffoldBg,
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
                SliverToBoxAdapter(
                  child: _HomeTopSection(viewModel: _viewModel),
                ),
                // Placeholder temporal
                const SliverToBoxAdapter(child: SizedBox(height: 300)),
              ],
            ),
          };
        },
      ),
    );
  }
}

/// Unified top section: green background + search bar + Hot Vacancies carousel.
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
            SizedBox(height: topPadding + SpacingTokens.spacing4),

            // ===== Welcome Back & Notification bell =====
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('home.welcome_back'),
                    style: context.dsTextTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(220),
                    ),
                  ),

                  DSCircularIcon.icon(
                    IconsaxPlusLinear.notification,
                    iconColor: Colors.white,
                    backgroundColor: Colors.white.withAlpha(50),
                    onPressed: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing12),

            // ===== Main title =====
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: Text(
                context.tr('home.lets_find_job'),
                style: context.dsTextTheme.headlineMedium?.copyWith(
                  fontWeight: TypographyTokens.fontWeightBold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: SpacingTokens.spacing32),

            // ===== Search Bar (Faux — navigates to SearchScreen) =====
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: DSSearchBar(
                hintText: context.tr('home.search_hint'),
                hintColor: _kHintColor,
                icon: IconsaxPlusLinear.search_normal_1,
                onTap: () {
                  // TODO: Navigate to SearchScreen
                },
              ),
            ),
            const SizedBox(height: SpacingTokens.spacing32),

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
                    networkIconBackground: _kNetworkIconBg,
                    svgIconBackground: _kSvgIconBg,
                    onTap: () {},
                  );
                },
              ),
            ),

            const SizedBox(height: SpacingTokens.spacing16),
          ],
        ),
      ],
    );
  }
}
