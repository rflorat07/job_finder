/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.onboarding)` instead of `context.go('/')`.
abstract final class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';
  static const String getStarted = '/get-started';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String newPassword = '/new-password';
  static const String home = '/';
  static const String search = '/search';
  static const String explore = '/explore';
  static const String mostRecent = '/most-recent';
  static const String latestJobs = '/latest-jobs';
  static const String jobDetail = '/job-detail';
  static const String interviews = '/interviews';
  static const String inbox = '/inbox';
  static const String messageDetail = '/inbox/chat';
  static const String notifications = '/notifications';
  static const String account = '/account';
  static const String accountPersonalData = '/account/personal-data';
  static const String accountLanguage = '/account/language';
  static const String accountAppearance = '/account/appearance';
  static const String accountEditProfile = '/account/edit-profile';
  static const String profileAboutMe = '/account/edit-profile/about-me';
  static const String profileEducation = '/account/edit-profile/education';
  static const String profileWorkExperience =
      '/account/edit-profile/work-experience';
  static const String profileSkills = '/account/edit-profile/skills';
  static const String profileSalary = '/account/edit-profile/salary';
  static const String setupAccountStep1 = '/setup-account/step-1';
  static const String setupAccountStep2 = '/setup-account/step-2';
  static const String setupAccountStep3 = '/setup-account/step-3';
  static const String setupAccountStep4 = '/setup-account/step-4';
}
