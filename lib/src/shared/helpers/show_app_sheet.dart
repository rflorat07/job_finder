import 'dart:ui';

import 'package:job_design_tokens/job_design_tokens.dart';

import '../../imports/imports.dart';

/// Shows a highly customizable bottom sheet with premium features like backdrop blur.
///
/// This helper uses the [rootNavigatorKey] to display the sheet
/// without needing a local [BuildContext].
Future<T?> showAppSheet<T>({
  required Widget child,
  bool hasBlur = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  final context = rootContext;
  if (context == null) return Future.value(null);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: context.dsTheme.tabBarTheme.indicatorColor?.withValues(
      alpha: 0.2,
    ),
    elevation: 0,
    useSafeArea: useSafeArea,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: hasBlur ? 3 : 0,
          sigmaY: hasBlur ? 3 : 0,
        ),
        child: SizedBox(
          child: child,
        ),
      ),
    ),
  );
}

/// Shows a reusable confirmation sheet and returns the user's choice.
///
/// Returns `true` when user confirms, `false` when user cancels, and
/// `null` when the sheet is dismissed from outside.
Future<bool?> showConfirmationSheet({
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  IconData icon = Icons.warning_rounded,
  Color? iconColor,
  Color? iconBackgroundColor,
  Color? iconBorderColor,
  Color? confirmForegroundColor,
  Color? confirmBackgroundColor,
  bool hasBlur = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  return showAppSheet<bool>(
    hasBlur: hasBlur,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    child: AppConfirmationSheet(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      iconBorderColor: iconBorderColor,
      confirmForegroundColor: confirmForegroundColor,
      confirmBackgroundColor: confirmBackgroundColor,
    ),
  );
}
