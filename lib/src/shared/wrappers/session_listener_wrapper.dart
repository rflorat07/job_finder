import '../../imports/imports.dart';

class SessionListenerWrapper extends StatelessWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return child;
  }
}
