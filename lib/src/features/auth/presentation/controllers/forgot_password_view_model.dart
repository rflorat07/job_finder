import 'package:job_finder/src/imports/imports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  ForgotPasswordViewModel({required this.authRepository});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> sendResetLink(
    String email, {
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authRepository.sendOtpToEmail(email: email);
      onSuccess();
    } on AuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError('An error occurred while sending the code.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
