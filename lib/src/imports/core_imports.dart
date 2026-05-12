// Flutter SDK

export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';

// Project Core — everything exported through shared.dart (theme, extensions,
// utils, widgets, enums) plus routing and services.

export '../features/auth/presentation/screens/screens.dart';
export '../features/home/presentation/screens/screens.dart';
export '../features/onboarding/presentation/screens/screens.dart';
export '../features/setup/presentation/screens/screens.dart';
// Core
export '../routing/app_router.dart';
export '../routing/app_routes.dart';
export '../routing/global_navigator.dart';
// Helpers
export '../shared/shared.dart';
export '../utils/utils.dart';
