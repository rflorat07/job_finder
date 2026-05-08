import '../imports/imports.dart';

/// Routes that require an authenticated session.
const _protectedRoutes = [AppRoutes.home];

/// Routes accessible only to unauthenticated users.
const _authOnlyRoutes = [
  AppRoutes.onboarding,
  AppRoutes.getStarted,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
  AppRoutes.otpVerification,
];

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,
  redirect: (context, state) {
    //final container = ProviderScope.containerOf(context, listen: false);
    //final session = container.read(sessionProvider);
    //return AppRoutes.otpVerification;
    return state.fullPath ?? AppRoutes.login;
    // return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.getStarted,
      name: 'getStarted',
      builder: (context, state) => const GetStartedScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      pageBuilder: (context, state) => AppTransitions.slideUp(
        context: context,
        state: state,
        child: const ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otpVerification',
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: const OtpVerificationScreen(),
      ),
    ),
    /*
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ), */
  ],
);
