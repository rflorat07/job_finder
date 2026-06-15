import 'package:job_design_tokens/job_design_tokens.dart';

import '../../../../imports/imports.dart';
import '../models/account_section_item.dart';
import 'account_menu_row.dart';

class AccountSection extends StatelessWidget {
  final AccountSectionItem section;

  const AccountSection({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: context.dsTextTheme.bodyMedium?.copyWith(
            color: context.dsColors.onSurfaceVariant,
            fontWeight: TypographyTokens.fontWeightRegular,
          ),
        ),
        const SizedBox(height: SpacingTokens.spacing8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: section.items.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: SpacingTokens.zero),
          itemBuilder: (context, index) {
            final item = section.items[index];
            return AccountMenuRow(
              title: item.title,
              icon: item.icon,
              onTap: item.onTap,
              trailingText: item.trailingText,
              showChevron: item.showChevron,
            );
          },
        ),
      ],
    );
  }
}
