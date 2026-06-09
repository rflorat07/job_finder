import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// Notification card component matching the app's notification list design.
class DSNotificationCard extends StatelessWidget {
  static const double _kMinCardHeight = 131;

  final String title;
  final String description;
  final String timeLabel;
  final String? avatarUrl;
  final String fallbackEmoji;
  final bool isRead;
  final VoidCallback? onTap;

  const DSNotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.timeLabel,
    this.avatarUrl,
    this.fallbackEmoji = '🔔',
    this.isRead = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isRead
        ? Colors.transparent
        : context.dsColors.primary.withAlpha(75);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: RadiusTokens.lgRadius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: context.dsColors.secondaryContainer,
            borderRadius: RadiusTokens.lgRadius,
            border: Border.all(color: borderColor),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _kMinCardHeight),
            child: Padding(
              padding: const EdgeInsets.all(SpacingTokens.spacing16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NotificationAvatar(
                    avatarUrl: avatarUrl,
                    fallbackEmoji: fallbackEmoji,
                  ),
                  const SizedBox(width: SpacingTokens.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.dsTextTheme.bodyMedium?.copyWith(
                                  fontWeight:
                                      TypographyTokens.fontWeightSemiBold,
                                  color: context.dsColors.onSurface,
                                  height:
                                      TypographyTokens.lineHeightExtraRelaxed,
                                  letterSpacing:
                                      TypographyTokens.letterSpacingTight,
                                ),
                              ),
                            ),
                            const SizedBox(width: SpacingTokens.spacing24),
                            Text(
                              timeLabel,
                              style: context.dsTextTheme.labelSmall?.copyWith(
                                fontWeight: TypographyTokens.fontWeightMedium,
                                color: context.dsColors.onSurfaceVariant,
                                height: TypographyTokens.lineHeightExtraRelaxed,
                                letterSpacing:
                                    TypographyTokens.letterSpacingTight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SpacingTokens.spacing8),
                        Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.dsTextTheme.bodySmall?.copyWith(
                            fontWeight: TypographyTokens.fontWeightRegular,
                            color: context.dsColors.onSurfaceVariant,
                            height: TypographyTokens.lineHeightExtraRelaxed,
                            letterSpacing: TypographyTokens.letterSpacingTight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String fallbackEmoji;

  const _NotificationAvatar({
    required this.avatarUrl,
    required this.fallbackEmoji,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return SizedBox(
        width: SizesTokens.size48,
        height: SizesTokens.size48,
        child: CircleAvatar(
          radius: SizesTokens.size24,
          backgroundImage: NetworkImage(avatarUrl!),
        ),
      );
    }

    return SizedBox(
      width: SizesTokens.size48,
      height: SizesTokens.size48,
      child: CircleAvatar(
        radius: SizesTokens.size24,
        backgroundColor: Color(PrimitiveColors.primary50),
        child: Center(
          child: Text(fallbackEmoji, style: context.dsTextTheme.bodyMedium),
        ),
      ),
    );
  }
}

@Preview(
  name: 'DSNotificationCard Preview - Light',
  brightness: Brightness.light,
)
Widget dsNotificationCardPreview() {
  return DsPreviewScaffold(
    children: [
      const DSNotificationCard(
        title: 'Networking Opportunity',
        timeLabel: '08:23 AM',
        description:
            'Expand your network, Aaron! Join our virtual networking event tomorrow to connect with industry leaders.',
        avatarUrl:
            'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=128&q=80',
        isRead: false,
      ),
    ],
  );
}
