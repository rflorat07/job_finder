// lib/src/features/auth/presentation/controllers/new_password_view_model.dart

import 'package:flutter/material.dart';

class NewPasswordViewModel extends ChangeNotifier {
  // final AuthRepository authRepository;
  // NewPasswordViewModel({required this.authRepository});

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> updatePassword(
    String password, {
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // await authRepository.updatePassword(password);
      await Future<void>.delayed(const Duration(seconds: 2)); // API Mock

      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
