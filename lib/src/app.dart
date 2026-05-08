import 'package:job_design_tokens/job_design_tokens.dart';

import 'imports/imports.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Job Finder',
      theme: DSThemeLight.build(),
      darkTheme: DSThemeDark.build(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      builder: (context, child) {
        Widget current = child!;
        current = SessionListenerWrapper(child: current);
        return current;
      },
    );
  }
}
