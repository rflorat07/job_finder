import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A job listing card displaying company logo, job title, metadata,
/// salary, tags, and an optional bookmark action.
///
/// Reusable across: Home (Best Matches), Search Results, Saved Jobs.
class DSJobCard extends StatelessWidget {
  /// Job position title (e.g. "Senior Product Designer").
  final String jobTitle;

  /// Company name (e.g. "Stripe").
  final String companyName;

  /// Location text (e.g. "San Francisco, CA").
  final String location;

  /// Salary range text (e.g. "\$120k - \$140k").
  final String salary;

  /// Company logo — can be a network URL or local SVG asset path.
  final String logoUrl;

  /// Tags displayed as chips (e.g. ["Remote", "Full-time"]).
  final List<String> tags;

  /// Time since posting (e.g. "2d ago").
  final String? timeAgo;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the bookmark icon is tapped.
  final VoidCallback? onBookmark;

  /// Whether the job is bookmarked.
  final bool isBookmarked;

  const DSJobCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.logoUrl,
    this.tags = const [],
    this.timeAgo,
    this.onTap,
    this.onBookmark,
    this.isBookmarked = false,
  });

  /// Resolves the logo icon based on whether [logoUrl] is a network URL or SVG.
  DSDynamicIcon _buildLogoIcon() {
    if (logoUrl.startsWith('http')) {
      return DSDynamicIcon.network(
        logoUrl,
        backgroundColor: const Color(0xFFF3F4F6),
      );
    }
    return DSDynamicIcon.svgAsset(
      logoUrl,
      backgroundColor: const Color(0xFFE5F1E5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.spacing16),
        decoration: BoxDecoration(
          color: context.dsColors.surface,
          borderRadius: RadiusTokens.lgRadius,
          border: Border.all(
            color: context.dsColors.outlineVariant.withAlpha(80),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Top row: Logo + Title/Company + Bookmark =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogoIcon(),
                const SizedBox(width: SpacingTokens.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        style: context.dsTextTheme.bodyMedium?.copyWith(
                          fontWeight: TypographyTokens.fontWeightSemiBold,
                          color: context.dsColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: SpacingTokens.spacing4),
                      Text(
                        '$companyName · $location',
                        style: context.dsTextTheme.bodySmall?.copyWith(
                          color: context.dsColors.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (onBookmark != null)
                  GestureDetector(
                    onTap: onBookmark,
                    child: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isBookmarked
                          ? context.dsColors.primary
                          : context.dsColors.secondary,
                      size: SizesTokens.size24,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: SpacingTokens.spacing12),

            // ===== Salary + Time ago =====
            Row(
              children: [
                Text(
                  salary,
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    fontWeight: TypographyTokens.fontWeightSemiBold,
                    color: context.dsColors.primary,
                  ),
                ),
                if (timeAgo != null) ...[
                  const Spacer(),
                  Text(
                    timeAgo!,
                    style: context.dsTextTheme.bodySmall?.copyWith(
                      color: context.dsColors.secondary,
                    ),
                  ),
                ],
              ],
            ),

            // ===== Tags =====
            if (tags.isNotEmpty) ...[
              const SizedBox(height: SpacingTokens.spacing12),
              Wrap(
                spacing: SpacingTokens.spacing8,
                runSpacing: SpacingTokens.spacing8,
                children: tags.map((tag) => _JobTag(label: tag)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lightweight tag chip for job cards (non-interactive).
class _JobTag extends StatelessWidget {
  final String label;

  const _JobTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing12,
        vertical: SpacingTokens.spacing4,
      ),
      decoration: BoxDecoration(
        color: context.dsColors.secondaryContainer,
        borderRadius: RadiusTokens.smRadius,
      ),
      child: Text(
        label,
        style: context.dsTextTheme.labelSmall?.copyWith(
          color: context.dsColors.secondary,
          fontWeight: TypographyTokens.fontWeightMedium,
        ),
      ),
    );
  }
}

@Preview(name: 'DSJobCard Preview - Light', brightness: Brightness.light)
@Preview(name: 'DSJobCard Preview - Dark', brightness: Brightness.dark)
Widget dsJobCardPreview() {
  return DsPreviewScaffold(
    children: [
      DSJobCard(
        jobTitle: 'Senior Product Designer',
        companyName: 'Stripe',
        location: 'San Francisco, CA',
        salary: '\$120k - \$140k',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQGluJhW7I1NYU7jF77E-9K9I46_ib_DUNHw&s',
        tags: ['Remote', 'Full-time'],
        timeAgo: '2d ago',
        isBookmarked: true,
        onBookmark: () {},
        onTap: () {},
      ),
      DSJobCard(
        jobTitle: 'Flutter Developer',
        companyName: 'Shopify',
        location: 'Toronto, Canada',
        salary: '\$90k - \$110k',
        logoUrl: 'assets/icons/shopify.svg',
        tags: ['Hybrid', 'Full-time'],
        timeAgo: '1d ago',
        onBookmark: () {},
        onTap: () {},
      ),
    ],
  );
}
