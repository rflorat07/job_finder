import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controls status bar icon contrast across design-system layouts.
enum DSSystemUiStyle { light, dark }

/// Maps [DSSystemUiStyle] to a ready-to-use [SystemUiOverlayStyle].
SystemUiOverlayStyle dsSystemUiOverlayStyle(DSSystemUiStyle style) {
  return switch (style) {
    DSSystemUiStyle.light => SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    DSSystemUiStyle.dark => SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  };
}
