import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Recibe la data lista y validada
  Future<void> login(
    String email,
    String password, {
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future<void>.delayed(const Duration(seconds: 2)); // Simulando API
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners(); // Ocultamos el spinner
    }
  }
}
