import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/entities/entities.dart';
import '../controllers/controllers.dart';

/// Hub screen ("Manage Profile") that previews the user's profile and links to
/// every editable section.
class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final datasource = SupabaseProfileRemoteDataSource(
      Supabase.instance.client,
    );
    final repository = ProfileRepositoryImpl(datasource);
    _viewModel = ProfileViewModel(repository);
    _viewModel.loadProfile();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  /// Pushes an edit route that shares [_viewModel], then refreshes on return.
  Future<void> _openEdit(String route) async {
    await context.push(route, extra: _viewModel);
    if (!mounted) {
      return;
    }
    // A reload keeps the preview in sync regardless of which section was
    // edited (Personal Data lives in its own feature/VM).
    await _viewModel.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('profile.manage_title'),
        backgroundColor: context.dsColors.primaryContainer,
        centerTitle: true,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return switch (_viewModel.state) {
            ProfileState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            ProfileState.error => DSErrorState(
              message:
                  _viewModel.errorMessage ??
                  context.tr('profile.generic_error'),
              retryLabel: context.tr('home.retry'),
              onRetry: _viewModel.loadProfile,
            ),
            ProfileState.loaded ||
            ProfileState.saving => _buildContent(context),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final profile = _viewModel.profile!;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(SpacingTokens.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileSummary(profile: profile),
            const SizedBox(height: SpacingTokens.spacing24),

            _ProfileSectionCard(
              title: context.tr('profile.about_me_title'),
              preview: profile.aboutMe,
              placeholder: context.tr('profile.about_me_placeholder'),
              onEdit: () => _openEdit(AppRoutes.profileAboutMe),
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            _ProfileSectionCard(
              title: context.tr('profile.personal_data_title'),
              preview: _personalDataPreview(profile),
              placeholder: context.tr('profile.personal_data_placeholder'),
              onEdit: () => _openPersonalData(),
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            _ProfileSectionCard(
              title: context.tr('profile.education_title'),
              preview: profile.school,
              placeholder: context.tr('profile.education_placeholder'),
              onEdit: () => _openEdit(AppRoutes.profileEducation),
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            _ProfileSectionCard(
              title: context.tr('profile.work_experience_title'),
              preview: profile.companyName,
              placeholder: context.tr('profile.work_experience_placeholder'),
              onEdit: () => _openEdit(AppRoutes.profileWorkExperience),
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            _ProfileSectionCard(
              title: context.tr('profile.skills_title'),
              preview: profile.skills.isEmpty
                  ? null
                  : profile.skills.join(', '),
              placeholder: context.tr('profile.skills_placeholder'),
              onEdit: () => _openEdit(AppRoutes.profileSkills),
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            _ProfileSectionCard(
              title: context.tr('profile.salary_title'),
              preview: profile.minimumSalary != null
                  ? context.tr(
                      'profile.salary_value',
                      namedArgs: {'value': profile.minimumSalary.toString()},
                    )
                  : null,
              placeholder: context.tr('profile.salary_placeholder'),
              onEdit: () => _openEdit(AppRoutes.profileSalary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPersonalData() async {
    await context.push(AppRoutes.accountPersonalData);
    if (!mounted) {
      return;
    }
    await _viewModel.loadProfile();
  }

  String? _personalDataPreview(ProfileEntity profile) {
    final parts = <String>[
      if (profile.fullName.isNotEmpty) profile.fullName,
      if (profile.phoneNumber?.isNotEmpty ?? false) profile.phoneNumber!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

/// Avatar + name + email block shown at the top of the hub.
class _ProfileSummary extends StatelessWidget {
  final ProfileEntity profile;

  const _ProfileSummary({required this.profile});

  @override
  Widget build(BuildContext context) {
    final hasAvatar =
        profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty;

    return Column(
      children: [
        SizedBox(
          width: SizesTokens.size80,
          height: SizesTokens.size80,
          child: CircleAvatar(
            radius: SizesTokens.size40,
            backgroundColor: context.dsColors.secondaryContainer,
            backgroundImage: hasAvatar
                ? CachedNetworkImageProvider(profile.avatarUrl!)
                : null,
            child: hasAvatar
                ? null
                : Icon(
                    IconsaxPlusLinear.user,
                    size: SizesTokens.size40,
                    color: context.dsColors.onSurfaceVariant,
                  ),
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing12),
        Text(
          profile.fullName.isNotEmpty
              ? profile.fullName
              : context.tr('profile.default_name'),
          textAlign: TextAlign.center,
          style: context.dsTextTheme.bodyMedium?.copyWith(
            color: context.dsColors.onSurface,
            fontWeight: TypographyTokens.fontWeightSemiBold,
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing4),
        Text(
          profile.email,
          textAlign: TextAlign.center,
          style: context.dsTextTheme.bodySmall?.copyWith(
            color: context.dsColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// A white rounded card representing one editable profile section.
class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final String? preview;
  final String placeholder;
  final VoidCallback onEdit;

  const _ProfileSectionCard({
    required this.title,
    required this.preview,
    required this.placeholder,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final hasPreview = preview != null && preview!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(SpacingTokens.spacing16),
      decoration: BoxDecoration(
        color: context.dsColors.secondaryContainer,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onSurface,
                  fontWeight: TypographyTokens.fontWeightSemiBold,
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  context.tr('profile.edit'),
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    color: context.dsColors.primary,
                    fontWeight: TypographyTokens.fontWeightSemiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.spacing8),
          Text(
            hasPreview ? preview! : placeholder,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: hasPreview
                  ? context.dsColors.onSurfaceVariant
                  : context.dsColors.onSurfaceVariant.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
