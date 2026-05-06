// Flutter SDK

export 'package:easy_localization/easy_localization.dart'
    hide TextDirection, MapExtension;
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter_native_splash/flutter_native_splash.dart';

export '../features/auth/presentation/screens/forgot_password_screen.dart';
// Project Core — everything exported through shared.dart (theme, extensions,
// utils, widgets, enums) plus routing and services.

export '../features/auth/presentation/screens/get_started_screen.dart';
export '../features/auth/presentation/screens/login_screen.dart';
export '../features/auth/presentation/screens/register_screen.dart';
export '../features/onboarding/presentation/screens/onboarding_page.dart';
export '../routing/app_router.dart';
export '../routing/app_routes.dart';
export '../routing/global_navigator.dart';
export '../shared/shared.dart';
export '../utils/utils.dart';
