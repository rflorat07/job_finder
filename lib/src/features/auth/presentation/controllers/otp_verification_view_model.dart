import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  OtpVerificationViewModel({required this.authRepository});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Simulates the OTP code verification against the server.
  Future<void> verifyCode(
    String email,
    String code, {
    required VoidCallback onSuccess,
    required void Function(String) onError,
  }) async {
    // Basic validation before sending the request to the server
    if (code.length != 5 && code.length != 6) {
      // Supabase typically uses 6 digits for OTP
      onError('The code must be exactly 6 digits.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.verifyEmailOtp(email: email, token: code);
      onSuccess();
    } on AuthRetryableFetchException {
      onError('Service is temporarily unavailable. Please try again.');
    } on AuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError('An error occurred during verification.');
    } finally {
      // Important: Ensure loading is turned off even if it succeeds or fails
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Extra method to handle the "Resend Code" functionality
  Future<void> resendCode(
    String email, {
    required VoidCallback onCodeResent,
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.sendOtpToEmail(email: email);
      onCodeResent();
    } on AuthRetryableFetchException {
      onError('Service is temporarily unavailable. Please try again.');
    } on AuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError('Error resending the code.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
