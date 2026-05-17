import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/imports.dart';

import '../controllers/controllers.dart';
import 'widgets/widgets.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dsColors.surface,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.spacing24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: SpacingTokens.spacing8),

                  // Skip button
                  OnBoardingSkip(onSkip: () => _controller.skip(context)),

                  const SizedBox(height: SpacingTokens.spacing16),

                  // PageView - takes all available space
                  Expanded(
                    child: PageView.builder(
                      controller: _controller.pageController,
                      itemCount: _controller.items.length,
                      onPageChanged: _controller.onPageChanged,
                      itemBuilder: (context, index) {
                        final item = _controller.items[index];
                        return OnboardingItem(
                          image: item.imagePath,
                          title: context.tr(item.titleKey),
                          subtitle: context.tr(item.subtitleKey),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: SpacingTokens.spacing32),

                  // Dot indicators
                  OnBoardingDotNavigation(
                    count: _controller.items.length,
                    activeIndex: _controller.currentPage,
                  ),

                  const SizedBox(height: SpacingTokens.spacing48),

                  // Next button
                  DSButton(
                    label: _controller.isLastPage
                        ? context.tr('shared.get_started')
                        : '',
                    iconOnly: !_controller.isLastPage,
                    type: DSButtonType.primary,
                    size: DSButtonSize.large,
                    icon: _controller.isLastPage
                        ? null
                        : const Icon(IconsaxPlusLinear.arrow_right_3),
                    onPressed: () => _controller.nextPage(context),
                  ),

                  const SizedBox(height: SpacingTokens.spacing24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
