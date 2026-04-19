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
      home: const Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
