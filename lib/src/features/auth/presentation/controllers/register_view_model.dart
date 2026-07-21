// lib/src/features/auth/presentation/controllers/register_view_model.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  RegisterViewModel({required this.authRepository});

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

  /// Attempts to register a new user.
  /// Calls [onSuccess] if successful, or [onError] with a message if it fails.
  Future<void> register(
    String email,
    String password, {
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.signUpWithEmail(email: email, password: password);
      onSuccess();
    } on AuthRetryableFetchException {
      onError('Service is temporarily unavailable. Please try again.');
    } on AuthException catch (e) {
      // Supabase specific errors
      onError(e.message);
    } catch (e) {
      // Generic errors
      onError('An error occurred during registration.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
