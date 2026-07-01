import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:job_finder/src/app.dart';
import 'package:job_finder/src/shared/services/theme_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/imports/imports.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before any asynchronous operations
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Preserve the splash screen until we load environment variables and initialize localization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variable
  await dotenv.load(fileName: '.env');

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Ensure localization is initialized before running the app
  await EasyLocalization.ensureInitialized();

  // Load persisted theme preference
  await themeService.load();

  runApp(const LocalizationWrapper(child: MainApp()));
}
