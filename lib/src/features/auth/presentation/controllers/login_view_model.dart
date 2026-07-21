import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  LoginViewModel({required this.authRepository});

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Attempts to authenticate the user.
  /// Calls [onError] with a human-readable message if the login fails.
  Future<void> login(
    String email,
    String password, {
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // We wait for the repository to do the actual work
      await authRepository.signInWithEmail(email: email, password: password);
    } on AuthRetryableFetchException {
      onError('Service is temporarily unavailable. Please try again.');
    } on AuthException catch (e) {
      // Supabase specific errors
      onError(e.message);
    } catch (e) {
      // Generic errors (e.g. no internet)
      onError('An error occurred during login.');
    } finally {
      _isLoading = false;
      notifyListeners(); // Ocultamos el spinner
    }
  }
}
