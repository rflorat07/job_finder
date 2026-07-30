import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

/// Screen that lets the user manage their account security preferences:
/// remembering the password, biometric sign-in options and a shortcut to
/// change the password.
///
/// Toggles hold ephemeral UI state only (no backend wiring yet), so a
/// [StatefulWidget] with local state is the right level of abstraction here.
class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _rememberPassword = true;
  bool _faceId = false;
  bool _biometricId = true;

  void _onGoogleAuthenticatorTap() {
    // TODO: Navigate to the Google Authenticator setup flow when available.
  }

  void _onChangePassword() {
    // TODO: Navigate to the Change Password flow when available.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('account.account_security'),
        backgroundColor: context.dsColors.primaryContainer,
        leading: DSCircularIcon.icon(
          IconsaxPlusLinear.arrow_left_1,
          size: SizesTokens.size44,
          iconSize: SizesTokens.size24,
          backgroundColor: context.dsColors.secondaryContainer,
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(SpacingTokens.spacing24),
        child: Column(
          children: [
            _SecurityCard(
              children: [
                _SecurityToggleRow(
                  label: context.tr('account.security_remember_password'),
                  value: _rememberPassword,
                  onChanged: (value) =>
                      setState(() => _rememberPassword = value),
                ),
                _SecurityToggleRow(
                  label: context.tr('account.security_face_id'),
                  value: _faceId,
                  onChanged: (value) => setState(() => _faceId = value),
                ),
                _SecurityToggleRow(
                  label: context.tr('account.security_biometric_id'),
                  value: _biometricId,
                  onChanged: (value) => setState(() => _biometricId = value),
                ),
                _SecurityNavRow(
                  label: context.tr('account.security_google_authenticator'),
                  onTap: _onGoogleAuthenticatorTap,
                ),
              ],
            ),
            const SizedBox(height: SpacingTokens.spacing24),
            DSButton(
              label: context.tr('account.security_change_password'),
              onPressed: _onChangePassword,
              customStyle: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  context.dsColors.onSecondaryContainer,
                ),
                foregroundColor: WidgetStatePropertyAll(
                  context.dsColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White rounded container that groups the security rows, matching the design.
class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.dsColors.secondaryContainer,
        borderRadius: RadiusTokens.lgRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1)
                Divider(
                  height: SpacingTokens.zero,
                  thickness: 1,
                  color: context.dsColors.outlineVariant,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A single row with a label and a trailing [Switch].
class _SecurityToggleRow extends StatelessWidget {
  const _SecurityToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingTokens.spacing16),
      child: Row(
        spacing: SpacingTokens.spacing16,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.dsTextTheme.bodyMedium?.copyWith(
                color: context.dsColors.onSurface,
                fontWeight: TypographyTokens.fontWeightMedium,
                height: TypographyTokens.lineHeightInput,
              ),
            ),
          ),

          DSSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// A single row with a label and a trailing chevron that navigates forward.
class _SecurityNavRow extends StatelessWidget {
  const _SecurityNavRow({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: SpacingTokens.spacing16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.dsTextTheme.bodyMedium?.copyWith(
                  color: context.dsColors.onSurface,
                  fontWeight: TypographyTokens.fontWeightMedium,
                  height: TypographyTokens.lineHeightInput,
                ),
              ),
            ),
            const SizedBox(width: SpacingTokens.spacing12),
            Icon(
              IconsaxPlusLinear.arrow_right_3,
              size: SizesTokens.size24,
              color: context.dsColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
