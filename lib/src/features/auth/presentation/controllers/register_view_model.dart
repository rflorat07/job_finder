// lib/src/features/auth/presentation/controllers/register_view_model.dart

import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  // final AuthRepository authRepository;
  // RegisterViewModel({required this.authRepository});

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

  Future<void> register(
    String email,
    String password, {
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // await authRepository.register(email, password);
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
