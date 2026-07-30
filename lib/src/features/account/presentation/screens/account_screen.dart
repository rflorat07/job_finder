import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../imports/imports.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../controllers/controllers.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final AccountViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    final datasource = SupabaseAccountRemoteDataSource(
      Supabase.instance.client,
    );
    final repository = AccountRepositoryImpl(datasource);
    _viewModel = AccountViewModel(repository);
    _viewModel.loadProfile();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _onLogout() async {
    final success = await _viewModel.logout();
    if (!mounted) {
      return;
    }

    if (!success) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.errorMessage ?? context.tr('account.generic_error'),
          ),
        ),
      );
      return;
    }

    context.go(AppRoutes.login);
  }

  Future<void> _onLogoutPressed() async {
    if (_viewModel.state == AccountState.signingOut) {
      return;
    }

    final shouldLogout = await showAccountLogoutConfirmationSheet();

    if (shouldLogout != true) {
      return;
    }

    await _onLogout();
  }

  List<AccountSectionItem> _buildSections(BuildContext context) {
    return [
      AccountSectionItem(
        title: context.tr('account.personal_info'),
        items: [
          AccountMenuItem(
            title: context.tr('account.personal_data'),
            icon: IconsaxPlusLinear.user,
            onTap: () => context.push(AppRoutes.accountPersonalData),
          ),
          AccountMenuItem(
            title: context.tr('account.payment_account'),
            icon: IconsaxPlusLinear.card,
          ),
          AccountMenuItem(
            title: context.tr('account.account_security'),
            icon: IconsaxPlusLinear.security_safe,
            onTap: () => context.push(AppRoutes.accountSecurity),
          ),
        ],
      ),
      AccountSectionItem(
        title: context.tr('account.general'),
        items: [
          AccountMenuItem(
            title: context.tr('account.language'),
            icon: IconsaxPlusLinear.global,
            onTap: () => context.push(AppRoutes.accountLanguage),
          ),
          AccountMenuItem(
            title: context.tr('account.appearance'),
            icon: IconsaxPlusLinear.sun_1,
            onTap: () => context.push(AppRoutes.accountAppearance),
          ),
          AccountMenuItem(
            title: context.tr('account.push_notifications'),
            icon: IconsaxPlusLinear.notification,
            onTap: () => context.push(AppRoutes.accountPushNotifications),
          ),
          AccountMenuItem(
            title: context.tr('account.clear_cache'),
            icon: IconsaxPlusLinear.trash,
            trailingText: context.tr('account.clear_cache_size'),
            showChevron: false,
          ),
        ],
      ),
      AccountSectionItem(
        title: context.tr('account.about'),
        items: [
          AccountMenuItem(
            title: context.tr('account.support_center'),
            icon: IconsaxPlusLinear.info_circle,
          ),
          AccountMenuItem(
            title: context.tr('account.privacy_policy'),
            icon: IconsaxPlusLinear.shield_tick,
          ),
          AccountMenuItem(
            title: context.tr('account.about_app'),
            icon: IconsaxPlusLinear.info_circle,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final profile = _viewModel.profile;
        final fullName =
            profile?.fullName ?? context.tr('account.default_name');
        final email = profile?.email ?? context.tr('account.default_email');

        return DSBaseLayout(
          systemUiStyle: DSSystemUiStyle.light,
          backgroundColor: context.dsColors.primary,
          containerPadding: const EdgeInsets.fromLTRB(
            SpacingTokens.spacing24,
            SpacingTokens.spacing24,
            SpacingTokens.spacing24,
            SpacingTokens.spacing4,
          ),
          header: AccountHeader(
            fullName: fullName,
            email: email,
            avatarUrl: profile?.avatarUrl,
            onEditTap: () => context.push(AppRoutes.accountEditProfile),
          ),
          child: switch (_viewModel.state) {
            AccountState.loading => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            AccountState.error => _AccountErrorState(
              onRetry: _viewModel.loadProfile,
              message: _viewModel.errorMessage,
            ),
            AccountState.loaded ||
            AccountState.signingOut => _AccountLoadedState(
              sections: _buildSections(context),
              onLogoutPressed: _onLogoutPressed,
              isSigningOut: _viewModel.state == AccountState.signingOut,
            ),
          },
        );
      },
    );
  }
}

class _AccountLoadedState extends StatelessWidget {
  final List<AccountSectionItem> sections;
  final VoidCallback onLogoutPressed;
  final bool isSigningOut;

  const _AccountLoadedState({
    required this.sections,
    required this.onLogoutPressed,
    required this.isSigningOut,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: sections.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: SpacingTokens.spacing8),
            itemBuilder: (context, index) => AccountSection(
              section: sections[index],
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing16),

        AccountLogoutButton(
          isLoading: isSigningOut,
          onPressed: isSigningOut ? null : onLogoutPressed,
        ),
      ],
    );
  }
}

class _AccountErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;
  final String? message;

  const _AccountErrorState({
    required this.onRetry,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? context.tr('account.generic_error'),
            textAlign: TextAlign.center,
            style: context.dsTextTheme.bodyLarge,
          ),
          const SizedBox(height: SpacingTokens.spacing16),
          DSButton(
            label: context.tr('home.retry'),
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
