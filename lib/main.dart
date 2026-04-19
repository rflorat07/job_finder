import 'package:job_finder/src/app.dart';

import 'src/imports/core_imports.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await EasyLocalization.ensureInitialized();

  runApp(const LocalizationWrapper(child: MainApp()));
}
