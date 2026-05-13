import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/setup/presentation/controllers/setup_account_view_model.dart';
import '../imports/imports.dart';

/// Helper tool to convert a Stream into a Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Routes that require an authenticated session.
const _protectedRoutes = [
  AppRoutes.home,
  AppRoutes.setupAccountStep1,
  AppRoutes.setupAccountStep2,
  AppRoutes.setupAccountStep3,
  AppRoutes.setupAccountStep4,
];

/// Routes accessible only to unauthenticated users.
const _authOnlyRoutes = [
  AppRoutes.onboarding,
  AppRoutes.getStarted,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
  AppRoutes.otpVerification,
  AppRoutes.newPassword,
];

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,

  // 1. Tell GoRouter to recreate the navigation state whenever this stream emits a value.
  // We use our Supabase.instance auth changes.
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),

  redirect: (context, state) {
    // 2. Check the current session status synchronously
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    final currentPath = state.fullPath ?? '';
    final isGoingToProtected = _protectedRoutes.contains(currentPath);
    final isGoingToAuthOnly = _authOnlyRoutes.contains(currentPath);

    // 3. Logic Rules:
    // If the user is NOT logged in and tries to access a protected area -> Kick to Login
    if (!isLoggedIn && isGoingToProtected) {
      return AppRoutes.login;
    }

    // If the user IS logged in and tries to access onboarding/login/register -> Force to Home
    if (isLoggedIn && isGoingToAuthOnly) {
      // NOTE: Make sure the AppRoutes.home route is uncommented in your routes array!
      return AppRoutes.setupAccountStep1;
    }

    // If none of the conditions match, allow the navigation
    return null;
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
      pageBuilder: (context, state) {
        // Obtenemos el email pasado desde ForgotPassword
        final email = state.extra as String? ?? '';
        return AppTransitions.fade(
          context: context,
          state: state,
          child: OtpVerificationScreen(email: email),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.newPassword,
      name: 'newPassword',
      pageBuilder: (context, state) => AppTransitions.fade(
        context: context,
        state: state,
        child: const NewPasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.setupAccountStep1,
      name: 'setupAccountStep1',
      builder: (context, state) => const SetupAccountStep1Screen(),
    ),
    GoRoute(
      path: AppRoutes.setupAccountStep2,
      name: 'setupAccountStep2',
      pageBuilder: (context, state) {
        final viewModel = state.extra as SetupAccountViewModel;
        return AppTransitions.fade(
          context: context,
          state: state,
          child: SetupAccountStep2Screen(viewModel: viewModel),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
