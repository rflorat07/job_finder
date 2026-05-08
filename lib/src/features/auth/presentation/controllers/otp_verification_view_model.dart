import 'package:flutter/material.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Simulates the OTP code verification against the server.
  Future<void> verifyCode(
    String code, {
    required VoidCallback onSuccess,
    required void Function(String) onError,
  }) async {
    // Basic validation before sending the request to the server
    if (code.length != 5) {
      onError('The code must be exactly 5 digits.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Example: final result = await authRepository.verifyOtp(email, code);

      await Future<void>.delayed(const Duration(seconds: 2)); // API Mock

      // Simulating that the correct code is '12345' for testing purposes
      if (code == '12345') {
        onSuccess();
      } else {
        onError('Incorrect or expired code.');
      }
    } catch (e) {
      // Handle network or unexpected errors
      onError('Server connection error.');
    } finally {
      // Important: Ensure loading is turned off even if it succeeds or fails
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Extra method to handle the "Resend Code" functionality
  Future<void> resendCode({
    required VoidCallback onCodeResent,
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(seconds: 1)); // API Mock
      onCodeResent();
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
