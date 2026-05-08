import 'package:job_finder/src/imports/imports.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
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
      // await authRepository.sendPasswordResetEmail(email);
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
