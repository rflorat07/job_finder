import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A conversation row for the Inbox list: avatar, contact name, timestamp,
/// last message preview and an optional unread-count badge.
class DSConversationTile extends StatelessWidget {
  /// Contact display name.
  final String name;

  /// Contact avatar image URL.
  final String avatarUrl;

  /// Preview of the last message.
  final String lastMessage;

  /// Formatted timestamp (e.g. "8.30 AM").
  final String time;

  /// Number of unread messages. When 0 the badge is hidden.
  final int unreadCount;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  const DSConversationTile({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.spacing14),
        decoration: BoxDecoration(
          color: context.dsColors.secondaryContainer,
          borderRadius: RadiusTokens.lgRadius,
        ),
        child: Row(
          children: [
            _Avatar(url: avatarUrl),
            const SizedBox(width: SpacingTokens.spacing14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: context.dsTextTheme.bodyMedium?.copyWith(
                            color: context.dsColors.onSurface,
                            height: TypographyTokens.lineHeightExtraRelaxed,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: SpacingTokens.spacing8),
                      Text(
                        time,
                        style: context.dsTextTheme.labelSmall?.copyWith(
                          color: context.dsColors.secondary,
                          fontWeight: TypographyTokens.fontWeightMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SpacingTokens.spacing6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: context.dsTextTheme.bodySmall?.copyWith(
                            color: context.dsColors.secondary,
                            fontWeight: TypographyTokens.fontWeightRegular,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: SpacingTokens.spacing8),
                        _UnreadBadge(count: unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular contact avatar with graceful loading and error fallbacks.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: SizesTokens.size64,
        height: SizesTokens.size64,
        fit: BoxFit.cover,
        placeholder: (context, _) => Container(
          width: SizesTokens.size64,
          height: SizesTokens.size64,
          color: context.dsColors.primaryContainer,
        ),
        errorWidget: (context, _, _) => Container(
          width: SizesTokens.size64,
          height: SizesTokens.size64,
          color: context.dsColors.primaryContainer,
          child: Icon(
            Icons.person,
            color: context.dsColors.secondary,
            size: SizesTokens.size32,
          ),
        ),
      ),
    );
  }
}

/// Small red circular badge showing the unread message count.
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: SizesTokens.size20,
        minHeight: SizesTokens.size20,
      ),
      padding: const EdgeInsets.all(SpacingTokens.spacing4),
      decoration: BoxDecoration(
        color: context.dsColors.error,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: context.dsTextTheme.labelSmall?.copyWith(
          color: context.dsColors.onError,
          fontWeight: TypographyTokens.fontWeightMedium,
          height: 1,
        ),
      ),
    );
  }
}

@Preview(name: 'DSConversationTile Preview', brightness: Brightness.light)
Widget dsConversationTilePreview() {
  return DsPreviewScaffold(
    backgroundColor: const Color(PrimitiveColors.greyscale25),
    children: [
      DSConversationTile(
        name: 'Olivia Bennett',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        lastMessage: 'Lorem Ipsum is simply dummy text of the printing.',
        time: '8.30 AM',
        unreadCount: 2,
        onTap: () {},
      ),
      const SizedBox(height: SpacingTokens.spacing16),
      DSConversationTile(
        name: 'Noah Henderson',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        lastMessage: 'Lorem Ipsum is simply dummy text.',
        time: '8.30 AM',
        onTap: () {},
      ),
    ],
  );
}
