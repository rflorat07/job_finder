import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';

class AccountHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;
  final VoidCallback? onEditTap;

  const AccountHeader({
    super.key,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.spacing24,
        SpacingTokens.spacing20,
        SpacingTokens.spacing24,
        SpacingTokens.spacing24,
      ),
      child: Row(
        children: [
          _HeaderAvatar(avatarUrl: avatarUrl),
          const SizedBox(width: SpacingTokens.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.dsTextTheme.bodyMedium?.copyWith(
                    color: const Color(PrimitiveColors.neutral0),
                    height: TypographyTokens.lineHeightExtraRelaxed,
                  ),
                ),
                const SizedBox(height: SpacingTokens.spacing4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.dsTextTheme.bodySmall?.copyWith(
                    color: const Color(PrimitiveColors.neutral0),
                    fontWeight: TypographyTokens.fontWeightRegular,
                    height: TypographyTokens.lineHeightExtraRelaxed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: SpacingTokens.spacing12),
          DSCircularIcon.icon(
            IconsaxPlusLinear.edit_2,
            iconSize: SizesTokens.size24,
            iconColor: const Color(PrimitiveColors.neutral0),
            backgroundColor: context.dsColors.primary.withAlpha(70),
            onPressed: onEditTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _HeaderAvatar({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizesTokens.size80,
      height: SizesTokens.size80,
      child: CircleAvatar(
        radius: SizesTokens.size40,
        backgroundColor: context.dsColors.tertiaryContainer,
        backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
            ? CachedNetworkImageProvider(avatarUrl!)
            : null,
        child: avatarUrl == null || avatarUrl!.isEmpty
            ? Icon(
                IconsaxPlusLinear.user,
                size: SizesTokens.size40,
                color: context.dsColors.onSurfaceVariant,
              )
            : null,
      ),
    );
  }
}
