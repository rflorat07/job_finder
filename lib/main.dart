import 'package:job_finder/src/app.dart';

import 'src/imports/imports.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();

  runApp(const LocalizationWrapper(child: StateWrapper(child: MainApp())));
}
