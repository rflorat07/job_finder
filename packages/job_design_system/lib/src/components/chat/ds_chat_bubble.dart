import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A chat message bubble aligned left (received) or right (sent), with an
/// optional timestamp below it.
class DSChatBubble extends StatelessWidget {
  /// Message body text.
  final String message;

  /// Formatted timestamp shown under the bubble (e.g. "8.30 AM").
  final String time;

  /// Whether the message was sent by the current user.
  final bool isMine;

  const DSChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine
        ? context.dsColors.primary
        : context.dsColors.primary.withValues(alpha: 0.12);
    final textColor = isMine
        ? context.dsColors.onPrimary
        : context.dsColors.onSurface;

    final radius = Radius.circular(RadiusTokens.lg);
    final bubbleRadius = BorderRadius.only(
      topLeft: radius,
      topRight: radius,
      bottomLeft: isMine ? radius : Radius.zero,
      bottomRight: isMine ? Radius.zero : radius,
    );

    return Column(
      crossAxisAlignment: isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: context.dsWidth * 0.75),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.spacing16,
            vertical: SpacingTokens.spacing12,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: bubbleRadius,
          ),
          child: Text(
            message,
            style: context.dsTextTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: TypographyTokens.fontWeightRegular,
              height: TypographyTokens.lineHeightRelaxed,
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing8),
        Text(
          time,
          style: context.dsTextTheme.labelSmall?.copyWith(
            color: context.dsColors.secondary,
            fontWeight: TypographyTokens.fontWeightMedium,
            height: TypographyTokens.lineHeightExtraRelaxed,
          ),
        ),
      ],
    );
  }
}

@Preview(name: 'DSChatBubble Preview', brightness: Brightness.light)
Widget dsChatBubblePreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      const DSChatBubble(
        message: 'Hi! I recently came across the Sr. Java Developer position.',
        time: '8.30 AM',
        isMine: true,
      ),
      const SizedBox(height: SpacingTokens.spacing16),
      const DSChatBubble(
        message: 'Hi John! Thanks for reaching out. It is a great opportunity.',
        time: '8.30 AM',
        isMine: false,
      ),
    ],
  );
}
