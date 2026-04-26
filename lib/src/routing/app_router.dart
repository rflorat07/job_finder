import '../imports/imports.dart';

/// Routes that require an authenticated session.
const _protectedRoutes = [AppRoutes.home];

/// Routes accessible only to unauthenticated users.
const _authOnlyRoutes = [
  AppRoutes.onboarding,
  AppRoutes.getStarted,
  AppRoutes.login,
  AppRoutes.signup,
];

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    //final container = ProviderScope.containerOf(context, listen: false);
    //final session = container.read(sessionProvider);
    //return AppRoutes.getStarted;
    return state.fullPath ?? AppRoutes.onboarding;
    // return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const GetStartedScreen(),
    ),
    /*     GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ), */
  ],
);
