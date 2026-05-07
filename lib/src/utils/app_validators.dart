import '../imports/imports.dart';

class AppValidators {
  AppValidators._();

  /// Checks if data is null.
  static bool isNull(dynamic value) => value == null;

  /// Checks if string is a valid email.
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('auth.email_required');
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return context.tr('auth.email_invalid');
    }

    return null;
  }

  /// Checks if string is a valid password.
  static String? validatePassword(
    BuildContext context,
    String? value, {
    int minLength = 6,
  }) {
    if (value == null || value.isEmpty) {
      return context.tr('auth.password_required');
    }
    if (value.length < minLength) {
      return context.tr('auth.password_too_short');
    }
    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return context.tr('auth.confirm_password_required');
    }
    if (value != password) {
      return context.tr('auth.passwords_do_not_match');
    }
    return null;
  }

  /// Checks if string is empty.
  static bool isEmpty(String? s) => s == null || s.trim().isEmpty;

  static String? validateRequired(
    BuildContext context,
    String? value,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('errors.field_required', args: [fieldName]);
    }
    return null;
  }

  /// Checks if string is phone number.
  static bool isPhoneNumber(String s) {
    if (s.length > 16 || s.length < 9) return false;
    return hasMatch(s, r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  }

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }

  /// Checks if string is URL.
  static bool isURL(String s) => hasMatch(
    s,
    r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&%\$#\=~_\-]+))*$",
  );
}
