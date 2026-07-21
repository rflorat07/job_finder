import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/interviews_remote_datasource.dart';
import '../../data/repositories/interview_repository_impl.dart';
import '../../domain/entities/interview_entity.dart';
import '../controllers/interviews_view_model.dart';

/// Interviews screen with an "Ongoing / History" segmented control and a
/// scrollable list of interview cards.
class InterviewsScreen extends StatefulWidget {
  const InterviewsScreen({super.key});

  @override
  State<InterviewsScreen> createState() => _InterviewsScreenState();
}

class _InterviewsScreenState extends State<InterviewsScreen> {
  late final InterviewsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final datasource = SupabaseInterviewsRemoteDataSource(client);
    final repository = InterviewRepositoryImpl(datasource);
    _viewModel = InterviewsViewModel(repository);
    _viewModel.loadInterviews();
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
        title: context.tr('interviews.title'),
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
        actions: [
          DSCircularIcon.icon(
            IconsaxPlusLinear.calendar,
            size: SizesTokens.size44,
            iconSize: SizesTokens.size24,
            backgroundColor: context.dsColors.secondaryContainer,
            iconColor: context.dsColors.onSurface,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing24,
          ),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DSSegmentedTabs(
                    selectedIndex: _viewModel.selectedTabIndex,
                    onChanged: _viewModel.selectTab,
                    labels: [
                      context.tr('interviews.ongoing'),
                      context.tr('interviews.history'),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.spacing16),
                  Expanded(child: _InterviewsBody(viewModel: _viewModel)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Switches the content area based on the current [InterviewsState].
class _InterviewsBody extends StatelessWidget {
  const _InterviewsBody({required this.viewModel});

  final InterviewsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.state) {
      InterviewsState.loading => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      InterviewsState.error => _InterviewsError(
        message: viewModel.errorMessage,
        onRetry: viewModel.loadInterviews,
      ),
      InterviewsState.empty => const _InterviewsEmpty(),
      InterviewsState.loaded => _InterviewsList(
        interviews: viewModel.interviews,
      ),
    };
  }
}

/// Renders the list of interview cards for the selected tab.
class _InterviewsList extends StatelessWidget {
  const _InterviewsList({required this.interviews});

  final List<InterviewEntity> interviews;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: SpacingTokens.spacing32),
      itemCount: interviews.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: SpacingTokens.spacing16),
      itemBuilder: (context, index) {
        final interview = interviews[index];
        return DSInterviewCard(
          key: ValueKey(interview.id),
          title: interview.roleTitle,
          companyName: interview.companyName,
          logoUrl: interview.companyLogoUrl,
          actionLabel: context.tr('interviews.click_to_join'),
          onAction: () {},
          meta: [
            DSInterviewMeta(
              icon: IconsaxPlusLinear.calendar_1,
              label: context.tr('interviews.date'),
              value: DateFormat('MMMM d, yyyy').format(interview.scheduledAt),
            ),
            DSInterviewMeta(
              icon: IconsaxPlusLinear.clock,
              label: context.tr('interviews.time'),
              value: DateFormat('h.mm a').format(interview.scheduledAt),
            ),
            DSInterviewMeta(
              icon: IconsaxPlusLinear.gallery,
              label: context.tr('interviews.media'),
              value: interview.media,
            ),
          ],
        );
      },
    );
  }
}

/// Error state with a retry action.
class _InterviewsError extends StatelessWidget {
  const _InterviewsError({required this.message, required this.onRetry});

  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? context.tr('interviews.generic_error'),
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
    );
  }
}

/// Placeholder shown when there are no interviews for the selected tab.
class _InterviewsEmpty extends StatelessWidget {
  const _InterviewsEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconsaxPlusLinear.calendar,
            size: SizesTokens.size48,
            color: context.dsColors.onSurfaceVariant,
          ),
          const SizedBox(height: SpacingTokens.spacing12),
          Text(
            context.tr('interviews.empty_title'),
            style: context.dsTextTheme.bodyMedium,
          ),
          const SizedBox(height: SpacingTokens.spacing8),
          Text(
            context.tr('interviews.empty_subtitle'),
            textAlign: TextAlign.center,
            style: context.dsTextTheme.bodyMedium?.copyWith(
              color: context.dsColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
