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
  AppRoutes.search,
  AppRoutes.interviews,
  AppRoutes.inbox,
  AppRoutes.notifications,
  AppRoutes.accountLanguage,
  AppRoutes.accountAppearance,
  AppRoutes.latestJobs,
  AppRoutes.mostRecent,
  AppRoutes.account,
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

/// Caché global para saber si el usuario ya completó el onboarding, evita leer la DB en cada cambio de ruta.
bool? setupCompletedCache;

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,

  // 1. Tell GoRouter to recreate the navigation state whenever this stream emits a value.
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange.map((event) {
      if (event.event == AuthChangeEvent.signedOut) {
        setupCompletedCache = null;
      }
      return event;
    }),
  ),

  redirect: (context, state) async {
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
      return AppRoutes.home;
    }

    // 4. Verificación del Setup Profile en Base de Datos
    if (isLoggedIn) {
      if (setupCompletedCache == null) {
        try {
          final response = await Supabase.instance.client
              .from('profiles')
              .select('setup_completed')
              .eq('id', session.user.id)
              .single();
          setupCompletedCache = response['setup_completed'] as bool? ?? false;
        } catch (_) {
          setupCompletedCache = false;
        }
      }

      final isSetupRoute =
          currentPath == AppRoutes.setupAccountStep1 ||
          currentPath == AppRoutes.setupAccountStep2 ||
          currentPath == AppRoutes.setupAccountStep3 ||
          currentPath == AppRoutes.setupAccountStep4;

      // Si NO ha completado el setup, y va a una ruta protegida (ej: Home) -> Mandarlo forzado al Step 1
      if (setupCompletedCache == false && isGoingToProtected && !isSetupRoute) {
        return AppRoutes.setupAccountStep1;
      }

      // Si YA completó el setup y por alguna razón intenta abrir las pantallas de setup -> Mandarlo a Home
      if ((setupCompletedCache ?? false) && isSetupRoute) {
        return AppRoutes.home;
      }
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
      path: AppRoutes.setupAccountStep3,
      name: 'setupAccountStep3',
      pageBuilder: (context, state) {
        final viewModel = state.extra as SetupAccountViewModel;
        return AppTransitions.fade(
          context: context,
          state: state,
          child: SetupAccountStep3Screen(viewModel: viewModel),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.setupAccountStep4,
      name: 'setupAccountStep4',
      pageBuilder: (context, state) {
        final viewModel = state.extra as SetupAccountViewModel;
        return AppTransitions.fade(
          context: context,
          state: state,
          child: SetupAccountStep4Screen(viewModel: viewModel),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      pageBuilder: (context, state) => AppTransitions.slideUp(
        context: context,
        state: state,
        child: const NotificationsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.accountLanguage,
      name: 'accountLanguage',
      pageBuilder: (context, state) => AppTransitions.slideUp(
        context: context,
        state: state,
        child: const AccountLanguageScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.accountAppearance,
      name: 'accountAppearance',
      pageBuilder: (context, state) => AppTransitions.slideUp(
        context: context,
        state: state,
        child: const AccountAppearanceScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.latestJobs,
      name: 'latestJobs',
      builder: (context, state) => const LatestJobsScreen(),
    ),
    GoRoute(
      path: AppRoutes.mostRecent,
      name: 'mostRecent',
      builder: (context, state) => const TrendingJobsScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Inyectamos el shell (el layout base)
        return DashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        // Rama 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Rama 2: Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.search,
              name: 'search',
              builder: (context, state) =>
                  const SearchScreen(), // Pantalla placeholder
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.interviews,
              name: 'interviews',
              builder: (context, state) =>
                  const InterviewsScreen(), // Pantalla placeholder
            ),
          ],
        ),
        // Rama 3: Inbox
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.inbox,
              name: 'inbox',
              builder: (context, state) => const InboxScreen(),
            ),
          ],
        ),
        // Rama 4: Account
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.account,
              name: 'account',
              builder: (context, state) =>
                  const AccountScreen(), // Pantalla placeholder
            ),
          ],
        ),
      ],
    ),
  ],
);
