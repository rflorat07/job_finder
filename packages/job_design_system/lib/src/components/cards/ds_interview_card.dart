import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A single metadata entry rendered inside a [DSInterviewCard]
/// (e.g. Date, Time or Media).
class DSInterviewMeta {
  /// Leading icon shown next to the [label].
  final IconData icon;

  /// Descriptive label on the left (e.g. "Date").
  final String label;

  /// Value on the right (e.g. "December 20, 2024").
  final String value;

  const DSInterviewMeta({
    required this.icon,
    required this.label,
    required this.value,
  });
}

/// A card that summarizes a scheduled interview: company logo, role title,
/// company name, a set of metadata rows and a call-to-action button.
///
/// Reusable across: Interviews (Ongoing / History), Calendar details.
class DSInterviewCard extends StatelessWidget {
  /// Role/position title (e.g. "User Interface Designer").
  final String title;

  /// Company name (e.g. "Pinterest").
  final String companyName;

  /// Company logo — can be a network URL or a local SVG asset path.
  final String logoUrl;

  /// Metadata rows displayed between the header and the action button.
  final List<DSInterviewMeta> meta;

  /// Label for the call-to-action button (e.g. "Click to Join").
  final String actionLabel;

  /// Callback when the action button is tapped.
  final VoidCallback? onAction;

  /// Callback when the whole card is tapped.
  final VoidCallback? onTap;

  const DSInterviewCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.logoUrl,
    required this.meta,
    required this.actionLabel,
    this.onAction,
    this.onTap,
  });

  /// Resolves the logo icon based on whether [logoUrl] is a network URL or SVG.
  DSDynamicIcon _buildLogoIcon(Color backgroundColor) {
    if (logoUrl.startsWith('http')) {
      return DSDynamicIcon.network(logoUrl, backgroundColor: backgroundColor);
    }
    return DSDynamicIcon.svgAsset(logoUrl, backgroundColor: backgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.spacing16),
        decoration: BoxDecoration(
          color: context.dsColors.secondaryContainer,
          borderRadius: RadiusTokens.lgRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header: Logo + Title/Company =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLogoIcon(
                  context.dsIsDarkMode
                      ? SemanticColorsDark.iconBackgroundColor
                      : SemanticColorsLight.iconBackgroundColor,
                ),
                const SizedBox(width: SpacingTokens.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.dsTextTheme.bodyMedium?.copyWith(
                          color: context.dsColors.onSurface,
                          height: TypographyTokens.lineHeightExtraRelaxed,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: SpacingTokens.spacing4),
                      Text(
                        companyName,
                        style: context.dsTextTheme.bodySmall?.copyWith(
                          color: context.dsColors.secondary,
                          fontWeight: TypographyTokens.fontWeightRegular,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: SpacingTokens.spacing16),

            // ===== Metadata rows =====
            for (int i = 0; i < meta.length; i++) ...[
              _MetaRow(data: meta[i]),
              if (i != meta.length - 1)
                const SizedBox(height: SpacingTokens.spacing12),
            ],

            const SizedBox(height: SpacingTokens.spacing16),
            Divider(
              height: 1,
              thickness: 1,
              color: context.dsColors.outlineVariant,
            ),
            const SizedBox(height: SpacingTokens.spacing16),

            // ===== Action button =====
            _ActionButton(label: actionLabel, onPressed: onAction),
          ],
        ),
      ),
    );
  }
}

/// A metadata row with a leading icon + label on the left and a value
/// aligned to the right.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.data});

  final DSInterviewMeta data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          data.icon,
          size: SizesTokens.size20,
          color: context.dsColors.secondary,
        ),
        const SizedBox(width: SpacingTokens.spacing8),
        Text(
          data.label,
          style: context.dsTextTheme.bodySmall?.copyWith(
            color: context.dsColors.secondary,
            fontWeight: TypographyTokens.fontWeightRegular,
          ),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            data.value,
            textAlign: TextAlign.right,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: context.dsColors.onSurface,
              fontWeight: TypographyTokens.fontWeightRegular,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// A full-width tonal (soft primary) pill button used for the card action.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: SizesTokens.size48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.dsColors.primary.withValues(alpha: 0.12),
            borderRadius: RadiusTokens.border100Radius,
          ),
          child: Text(
            label,
            style: context.dsTextTheme.bodyMedium?.copyWith(
              color: context.dsColors.primary,
              fontWeight: TypographyTokens.fontWeightSemiBold,
            ),
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'DSInterviewCard Preview - Light', brightness: Brightness.light)
Widget dsInterviewCardPreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      DSInterviewCard(
        title: 'User Interface Designer',
        companyName: 'Pinterest',
        logoUrl: 'https://cdn-icons-png.flaticon.com/128/145/145808.png',
        actionLabel: 'Click to Join',
        onAction: () {},
        meta: const [
          DSInterviewMeta(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: 'December 20, 2024',
          ),
          DSInterviewMeta(
            icon: Icons.access_time,
            label: 'Time',
            value: '11.00 AM',
          ),
          DSInterviewMeta(
            icon: Icons.image_outlined,
            label: 'Media',
            value: 'Google Meet',
          ),
        ],
      ),
    ],
  );
}
