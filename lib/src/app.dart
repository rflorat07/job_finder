import 'package:job_design_system/job_design_system.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:job_finder/src/imports/core_imports.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Finder',
      theme: DSThemeLight.build(),
      darkTheme: DSThemeDark.build(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('home.welcome_home'.tr()),
                DSButton(
                  label: 'Button',
                  size: DSButtonSize.large,
                  iconLeft: Icons.chevron_left,
                  iconRight: Icons.chevron_right,
                  onPressed: () {},
                ),
                DSButton(
                  label: 'Button',
                  size: DSButtonSize.large,
                  iconLeft: Icons.chevron_left,
                  iconRight: Icons.chevron_right,
                  isDisabled: true,
                  onPressed: () {},
                ),
                DSButton(
                  label: 'Button',
                  size: DSButtonSize.large,
                  iconOnly: true,
                  iconRight: Icons.chevron_left,
                  onPressed: () {},
                ),
                DSButton(
                  label: 'Button',
                  size: DSButtonSize.large,
                  type: DSButtonType.secondary,
                  iconLeft: Icons.chevron_left,
                  iconRight: Icons.chevron_right,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
