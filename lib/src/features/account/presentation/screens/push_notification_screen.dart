import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

/// Screen that lets the user manage their push notification preferences
/// (master switch plus per-category toggles such as sound, vibrate or
/// promotional offers).
///
/// Toggles hold ephemeral UI state only (no backend wiring yet), so a
/// [StatefulWidget] with local state is the right level of abstraction here.
class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({super.key});

  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  bool _notifications = true;
  bool _sound = false;
  bool _vibrate = false;
  bool _specialOffers = false;
  bool _payments = false;
  bool _cashback = false;
  bool _appUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.primaryContainer,
      appBar: DSAppBar(
        title: context.tr('account.push_notifications'),
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
        child: _PushNotificationCard(
          groupLabel: context.tr('account.push_notifications_group'),
          children: [
            _PushToggleRow(
              label: context.tr('account.push_notifications_enabled'),
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
            ),
            _PushToggleRow(
              label: context.tr('account.push_sound'),
              value: _sound,
              onChanged: (value) => setState(() => _sound = value),
            ),
            _PushToggleRow(
              label: context.tr('account.push_vibrate'),
              value: _vibrate,
              onChanged: (value) => setState(() => _vibrate = value),
            ),
            _PushToggleRow(
              label: context.tr('account.push_special_offers'),
              value: _specialOffers,
              onChanged: (value) => setState(() => _specialOffers = value),
            ),
            _PushToggleRow(
              label: context.tr('account.push_payments'),
              value: _payments,
              onChanged: (value) => setState(() => _payments = value),
            ),
            _PushToggleRow(
              label: context.tr('account.push_cashback'),
              value: _cashback,
              onChanged: (value) => setState(() => _cashback = value),
            ),
            _PushToggleRow(
              label: context.tr('account.push_app_updates'),
              value: _appUpdates,
              onChanged: (value) => setState(() => _appUpdates = value),
            ),
          ],
        ),
      ),
    );
  }
}

/// White rounded container that groups the toggle rows under a small,
/// muted section label, matching the design.
class _PushNotificationCard extends StatelessWidget {
  const _PushNotificationCard({
    required this.groupLabel,
    required this.children,
  });

  final String groupLabel;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              groupLabel,
              style: context.dsTextTheme.bodySmall?.copyWith(
                color: context.dsColors.onSurfaceVariant,
                fontWeight: TypographyTokens.fontWeightMedium,
              ),
            ),
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

/// A single row with a label and a trailing [DSSwitch].
class _PushToggleRow extends StatelessWidget {
  const _PushToggleRow({
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
