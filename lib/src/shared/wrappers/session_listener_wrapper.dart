import '../../imports/imports.dart';

class SessionListenerWrapper extends ConsumerWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    appRouter.go(AppRoutes.onboarding);
    /* ref.listen<SessionState>(sessionProvider, (prev, next) {
      if (next.status != SessionStatus.unknown) {
        FlutterNativeSplash.remove();
        if (next.status == SessionStatus.authenticated) {
          appRouter.go(AppRoutes.home);
        } else if (next.status == SessionStatus.unauthenticated) {
          appRouter.go(AppRoutes.onboarding);
        }
      }
    }); */

    return child;
  }
}
