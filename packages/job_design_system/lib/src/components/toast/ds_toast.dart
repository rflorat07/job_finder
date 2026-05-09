// Archivo: packages/job_design_system/lib/src/components/toast/ds_toast.dart
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:job_design_tokens/job_design_tokens.dart';
import 'package:toastification/toastification.dart';

import '../components.dart';

class DSToast {
  DSToast._();

  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: context.dsTextTheme.bodySmall?.copyWith(
          color: context.dsColors.onSurface,
        ),
      ),
      primaryColor: context.dsColors.primary,
      backgroundColor: context.dsColors.surface,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: false,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: context.dsTextTheme.bodySmall?.copyWith(
          color: context.dsColors.error,
        ),
      ),
      primaryColor: context.dsColors.error,
      backgroundColor: context.dsColors.surface,
      autoCloseDuration: const Duration(seconds: 4),
      showProgressBar: false,
    );
  }
}

@Preview(name: 'DSToast Preview - Light', brightness: Brightness.light)
//@Preview(name: 'DSToast Preview - Dark', brightness: Brightness.dark)
Widget dsToastLightDarkPreview() {
  return ToastificationWrapper(
    child: MaterialApp(
      theme: DSThemeLight.build(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                spacing: SpacingTokens.spacing16,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DSButton(
                    label: 'Show Success Toast',
                    onPressed: () => DSToast.showSuccess(
                      context: context,
                      message: 'This is a success message!',
                    ),
                  ),
                  DSButton(
                    label: 'Show Error Toast',
                    onPressed: () => DSToast.showError(
                      context: context,
                      message: 'This is an error message!',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
