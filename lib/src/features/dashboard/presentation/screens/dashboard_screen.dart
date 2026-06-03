import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/imports.dart';

class DashboardScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardScreen({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomAppBar(
        color: context.dsColors.tertiaryContainer,
        child: SizedBox(
          height: SizesTokens.size56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: IconsaxPlusLinear.home_1,
                activeIcon: IconsaxPlusLinear.home_1,
                label: context.tr('tabs.home'),
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _goBranch(0),
              ),

              _NavBarItem(
                icon: IconsaxPlusLinear.search_normal_1,
                activeIcon: IconsaxPlusLinear.search_normal_1,
                label: context.tr('tabs.search'),
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _goBranch(1),
              ),

              _NavBarRoundedItem(
                icon: IconsaxPlusLinear.briefcase,
                onTap: () => _goBranch(2),
              ),

              _NavBarItem(
                icon: IconsaxPlusLinear.message,
                activeIcon: IconsaxPlusLinear.message,
                label: context.tr('tabs.inbox'),
                isSelected: navigationShell.currentIndex == 3,
                onTap: () => _goBranch(3),
              ),

              _NavBarItem(
                icon: IconsaxPlusLinear.user,
                activeIcon: IconsaxPlusLinear.user,
                label: context.tr('tabs.account'),
                isSelected: navigationShell.currentIndex == 4,
                onTap: () => _goBranch(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.dsColors.onPrimaryContainer
        : context.dsColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: SizesTokens.size50,
        height: SizesTokens.size48,
        child: Column(
          spacing: SpacingTokens.spacing4,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: SizesTokens.size24,
            ),
            Text(
              label,
              style: context.dsTextTheme.bodySmall?.copyWith(
                color: color,
                fontSize: TypographyTokens.fontSize12,
                fontWeight: isSelected
                    ? TypographyTokens.fontWeightBold
                    : TypographyTokens.fontWeightRegular,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarRoundedItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavBarRoundedItem({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.dsColors.primary;
    return InkWell(
      onTap: onTap,
      child: DSRoundedContainer(
        width: SizesTokens.size48,
        height: SizesTokens.size48,
        borderRadius: RadiusTokens.fullRadius,
        backgroundColor: color,
        child: Icon(
          icon,
          color: Colors.white,
          size: SizesTokens.size24,
        ),
      ),
    );
  }
}
