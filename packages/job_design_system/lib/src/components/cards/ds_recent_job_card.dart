import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../components.dart';

/// A compact job card designed for horizontal carousels (e.g. "Most Recent").
///
/// Fixed width of 300px with company logo, title, tags, description,
/// location and salary.
class DSRecentJobCard extends StatelessWidget {
  /// Job position title (e.g. "Project Manager").
  final String jobTitle;

  /// Company name (e.g. "Meta").
  final String companyName;

  /// Location text (e.g. "California, United States").
  final String location;

  /// Salary text (e.g. "\$400 /Month").
  final String salary;

  /// Short description or summary of the job.
  final String description;

  /// Company logo — can be a network URL or local SVG asset path.
  final String logoUrl;

  /// Tags displayed as chips (e.g. ["Full Time", "Design", "Remote"]).
  final List<String> tags;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the bookmark icon is tapped.
  final VoidCallback? onBookmark;

  /// Whether the job is bookmarked.
  final bool isBookmarked;

  /// Card width. Defaults to 300.
  final double width;

  const DSRecentJobCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.description,
    required this.logoUrl,
    this.tags = const [],
    this.onTap,
    this.onBookmark,
    this.isBookmarked = false,
    this.width = 300,
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
        width: width,
        padding: const EdgeInsets.all(SpacingTokens.spacing16),
        decoration: BoxDecoration(
          color: context.dsColors.secondaryContainer,
          borderRadius: RadiusTokens.lgRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Top row: Logo + Title/Company + Bookmark =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        jobTitle,
                        style: context.dsTextTheme.bodyMedium?.copyWith(
                          color: context.dsColors.onSurface,
                          height: TypographyTokens.lineHeightExtraRelaxed,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

                if (onBookmark != null)
                  GestureDetector(
                    onTap: onBookmark,
                    child: Icon(
                      isBookmarked ? Icons.favorite : Icons.favorite_border,
                      color: isBookmarked
                          ? context.dsColors.primary
                          : context.dsColors.secondary,
                      size: SizesTokens.size24,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: SpacingTokens.spacing16),

            // ===== Tags =====
            if (tags.isNotEmpty)
              Wrap(
                spacing: SpacingTokens.spacing8,
                runSpacing: SpacingTokens.spacing8,
                children: tags.map((tag) => _RecentJobTag(label: tag)).toList(),
              ),

            if (tags.isNotEmpty)
              const SizedBox(height: SpacingTokens.spacing16),

            // ===== Description =====
            Text(
              description,
              style: context.dsTextTheme.bodySmall?.copyWith(
                fontSize: TypographyTokens.fontSize12,
                color: context.dsColors.secondary,
                fontWeight: TypographyTokens.fontWeightRegular,
                height: TypographyTokens.lineHeightExtraRelaxed,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: SpacingTokens.spacing16),

            // ===== Location + Salary Row =====
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: SizesTokens.size16,
                  color: context.dsColors.secondary,
                ),
                const SizedBox(width: SpacingTokens.spacing4),
                Expanded(
                  child: Text(
                    location,
                    style: context.dsTextTheme.labelSmall?.copyWith(
                      color: context.dsColors.secondary,
                      fontWeight: TypographyTokens.fontWeightRegular,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  salary,
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    color: context.dsColors.onPrimaryContainer,
                    height: TypographyTokens.lineHeightExtraRelaxed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Lightweight tag chip for recent job cards (non-interactive).
class _RecentJobTag extends StatelessWidget {
  final String label;

  const _RecentJobTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.spacing8,
        vertical: SpacingTokens.spacing4,
      ),
      decoration: BoxDecoration(
        color: context.dsIsDarkMode
            ? SemanticColorsDark.companyBackgroundColor
            : SemanticColorsLight
                  .companyBackgroundColor, // Use surface color in dark mode for better contrast
        borderRadius: RadiusTokens.fullRadius,
      ),
      child: Text(
        label,
        style: context.dsTextTheme.labelSmall?.copyWith(
          color: context.dsColors.secondary,
          height: TypographyTokens.lineHeightExtraRelaxed,
        ),
      ),
    );
  }
}

@Preview(name: 'DSRecentJobCard Preview - Light', brightness: Brightness.light)
Widget dsRecentJobCardPreview() {
  return DsPreviewScaffold(
    children: [
      DSRecentJobCard(
        jobTitle: 'Project Manager',
        companyName: 'Meta',
        location: 'California, United States',
        salary: '\$400 /Month',
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        logoUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQGluJhW7I1NYU7jF77E-9K9I46_ib_DUNHw&s',
        tags: ['Full Time', 'Design', 'Remote'],
        isBookmarked: false,
        onBookmark: () {},
        onTap: () {},
      ),
    ],
  );
}
