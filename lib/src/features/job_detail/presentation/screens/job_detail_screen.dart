import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../data/datasources/job_detail_remote_datasource.dart';
import '../../data/repositories/job_detail_repository_impl.dart';
import '../controllers/job_detail_view_model.dart';

// ─── Semantic constants ────────────────────────────────────────────────────────
/// Diameter of the circular company logo that overlaps the sheet.
const double _kLogoSize = 64;

/// How far the logo overlaps above the white sheet edge.
const double _kLogoOverlap = 32;

/// Reserved space at the bottom of the scroll so content is not hidden
/// behind the floating "Apply" button.
const double _kApplyButtonReservedSpace = 120;

/// Height of the green header content (excluding the top safe-area inset).
/// Equals top padding + circular button height + bottom padding.
/// Used to position the overlapping logo exactly on the header/sheet seam.
///
/// The bottom padding ([SpacingTokens.spacing56]) is intentionally larger than
/// [_kLogoOverlap] so the logo keeps at least 24px of clearance from the title
/// (`bottomPadding - overlap = 56 - 32 = 24`).
const double _kHeaderContentHeight =
    SpacingTokens.spacing8 + SizesTokens.size44 + SpacingTokens.spacing56;

/// Payload passed to [JobDetailScreen] through GoRouter's `extra`.
///
/// Carrying the [initialJob] lets the screen paint instantly with the data
/// already loaded in the list, while the ViewModel refreshes it from Supabase.
class JobDetailArgs {
  final String id;
  final JobListingEntity? initialJob;

  const JobDetailArgs({required this.id, this.initialJob});
}

/// Job Detail screen — shows the full information of a single job listing.
///
/// Data is (re)fetched from Supabase by [JobDetailViewModel] using the job id.
class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key, required this.args});

  final JobDetailArgs args;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late final JobDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    final client = Supabase.instance.client;
    final datasource = SupabaseJobDetailRemoteDataSource(client);
    final repository = JobDetailRepositoryImpl(datasource);

    _viewModel = JobDetailViewModel(
      repository,
      initialJob: widget.args.initialJob,
    )..loadJob(widget.args.id);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final state = _viewModel.state;
        final job = _viewModel.job;
        final safeTop = context.dsSafeArea.top;
        final isLoaded = state == JobDetailState.loaded && job != null;

        return Stack(
          children: [
            // Green header + white rounded container that fills the screen.
            // DSBaseLayout owns the SafeArea, system UI style and the rounded
            // container, so the sheet always expands to the bottom.
            DSBaseLayout(
              containerColor: context.dsColors.surface,
              containerPadding: EdgeInsets.zero,
              header: _JobDetailHeader(onBack: () => context.pop()),
              child: switch (state) {
                JobDetailState.loading => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                JobDetailState.error => _JobDetailError(
                  message: _viewModel.errorMessage,
                  onRetry: () => _viewModel.loadJob(widget.args.id),
                ),
                JobDetailState.loaded => _JobDetailBody(job: job!),
              },
            ),

            // Company logo straddling the header/sheet seam. It lives in the
            // outer Stack (not inside DSBaseLayout) so it is NOT clipped by the
            // container's rounded corners.
            if (isLoaded)
              Positioned(
                top: safeTop + _kHeaderContentHeight - _kLogoOverlap,
                left: 0,
                right: 0,
                child: Center(
                  child: _CompanyLogo(logoUrl: job.companyLogoUrl),
                ),
              ),

            // Floating Apply button with a fading gradient backdrop.
            if (isLoaded)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _ApplyBar(jobTitle: job.jobTitle),
              ),
          ],
        );
      },
    );
  }
}

// ─── Header (green area) ───────────────────────────────────────────────────────

class _JobDetailHeader extends StatelessWidget {
  const _JobDetailHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // The top safe-area inset is handled by DSBaseLayout's SafeArea, so the
    // header only adds its own vertical spacing here.
    return Padding(
      padding: const EdgeInsets.only(
        top: SpacingTokens.spacing8,
        left: SpacingTokens.spacing24,
        right: SpacingTokens.spacing24,
        bottom: SpacingTokens.spacing56,
      ),
      child: Row(
        children: [
          DSCircularIcon.icon(
            IconsaxPlusLinear.arrow_left_1,
            size: SizesTokens.size44,
            iconSize: SizesTokens.size24,
            iconColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              context.tr('job_detail.title'),
              textAlign: TextAlign.center,
              style: context.dsTextTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: TypographyTokens.fontWeightBold,
              ),
            ),
          ),
          DSCircularIcon.icon(
            IconsaxPlusLinear.more,
            size: SizesTokens.size44,
            iconSize: SizesTokens.size24,
            iconColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
          ),
        ],
      ),
    );
  }
}

// ─── Loaded content ────────────────────────────────────────────────────────────

/// Scrollable body rendered inside the white container of [DSBaseLayout].
class _JobDetailBody extends StatelessWidget {
  const _JobDetailBody({required this.job});

  final JobListingEntity job;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.spacing24,
        SpacingTokens.spacing40,
        SpacingTokens.spacing24,
        _kApplyButtonReservedSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + company · location
          Center(
            child: Column(
              children: [
                Text(
                  job.jobTitle,
                  textAlign: TextAlign.center,
                  style: context.dsTextTheme.bodyLarge?.copyWith(
                    color: context.dsColors.onSurface,
                    fontWeight: TypographyTokens.fontWeightBold,
                  ),
                ),
                const SizedBox(height: SpacingTokens.spacing8),
                Text(
                  '${job.companyName}  •  ${job.location}',
                  textAlign: TextAlign.center,
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    color: context.dsColors.secondary,
                    fontWeight: TypographyTokens.fontWeightRegular,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: SpacingTokens.spacing24),

          // Stat cards: Salary · Job Type · Level
          Row(
            children: [
              Expanded(
                child: DSStatCard(
                  icon: IconsaxPlusBold.dollar_circle,
                  label: context.tr('job_detail.salary'),
                  value: job.salary,
                ),
              ),
              Expanded(
                child: DSStatCard(
                  icon: IconsaxPlusBold.clock,
                  label: context.tr('job_detail.job_type'),
                  value: _jobTypeLabel(context, job.jobType),
                ),
              ),
              Expanded(
                child: DSStatCard(
                  icon: IconsaxPlusBold.chart_1,
                  label: context.tr('job_detail.level'),
                  value:
                      job.experienceLevel ?? context.tr('job_detail.level_any'),
                ),
              ),
            ],
          ),

          const SizedBox(height: SpacingTokens.spacing24),

          // Job Description
          _SectionTitle(text: context.tr('job_detail.description')),
          const SizedBox(height: SpacingTokens.spacing6),
          Text(
            job.description?.trim().isNotEmpty ?? false
                ? job.description!
                : context.tr('job_detail.no_description'),
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: context.dsColors.secondary,
              fontWeight: TypographyTokens.fontWeightRegular,
              height: TypographyTokens.lineHeightExtraRelaxed,
            ),
          ),

          const SizedBox(height: SpacingTokens.spacing24),

          // Qualifications
          _SectionTitle(text: context.tr('job_detail.qualifications')),
          const SizedBox(height: SpacingTokens.spacing6),
          if (job.qualifications.isEmpty)
            Text(
              context.tr('job_detail.no_qualifications'),
              style: context.dsTextTheme.bodySmall?.copyWith(
                color: context.dsColors.secondary,
                fontWeight: TypographyTokens.fontWeightRegular,
                height: TypographyTokens.lineHeightExtraRelaxed,
              ),
            )
          else
            ...job.qualifications.map(
              (item) => _QualificationBullet(text: item),
            ),
        ],
      ),
    );
  }

  /// Maps a raw `job_type` value to a display label.
  String _jobTypeLabel(BuildContext context, String jobType) {
    return switch (jobType) {
      'full-time' => context.tr('job_detail.job_type_full_time'),
      'part-time' => context.tr('job_detail.job_type_part_time'),
      'contract' => context.tr('job_detail.job_type_contract'),
      _ => jobType,
    };
  }
}

// ─── Reusable local pieces ─────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.dsTextTheme.bodyMedium?.copyWith(
        color: context.dsColors.onSurface,
        fontWeight: TypographyTokens.fontWeightSemiBold,
      ),
    );
  }
}

class _QualificationBullet extends StatelessWidget {
  const _QualificationBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.dsTextTheme.bodySmall?.copyWith(
      color: context.dsColors.secondary,
      fontWeight: TypographyTokens.fontWeightRegular,
      height: TypographyTokens.lineHeightExtraRelaxed,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: textStyle),
          Expanded(child: Text(text, style: textStyle)),
        ],
      ),
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo({required this.logoUrl});

  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kLogoSize,
      height: _kLogoSize,
      padding: const EdgeInsets.all(SpacingTokens.spacing6),
      decoration: BoxDecoration(
        color: context.dsColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: context.dsColors.surface,
          width: SizesTokens.size6,
        ),
      ),
      child: ClipOval(
        child: logoUrl.startsWith('http')
            ? DSDynamicIcon.network(logoUrl, size: _kLogoSize)
            : DSDynamicIcon.svgAsset(logoUrl, size: _kLogoSize),
      ),
    );
  }
}

class _ApplyBar extends StatelessWidget {
  const _ApplyBar({required this.jobTitle});

  final String jobTitle;

  @override
  Widget build(BuildContext context) {
    final surface = context.dsColors.surface;

    return Container(
      padding: EdgeInsets.only(
        left: SpacingTokens.spacing24,
        right: SpacingTokens.spacing24,
        top: SpacingTokens.spacing24,
        bottom: context.dsSafeArea.bottom + SpacingTokens.spacing16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [surface.withValues(alpha: 0), surface],
        ),
      ),
      child: DSButton(
        label: context.tr('job_detail.apply'),
        onPressed: () => DSToast.showSuccess(
          context: context,
          message: context.tr(
            'job_detail.applied_success',
            namedArgs: {'job': jobTitle},
          ),
        ),
      ),
    );
  }
}

// ─── Error state ───────────────────────────────────────────────────────────────

class _JobDetailError extends StatelessWidget {
  const _JobDetailError({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return DSErrorState(
      message: message ?? context.tr('job_detail.generic_error'),
      retryLabel: context.tr('job_detail.retry'),
      onRetry: onRetry,
    );
  }
}
