import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;
  final bool isPasswordVisible;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.errorMessage,
  });

  // Getter derivado útil: ¿Es válido el formulario para intentar enviar?
  bool get isValid =>
      email.isNotEmpty && email.contains('@') && password.length >= 6;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    bool? isPasswordVisible,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  LoginState clearError() => copyWith(errorMessage: null);

  @override
  List<Object?> get props => [
    email,
    password,
    isLoading,
    isPasswordVisible,
    errorMessage,
  ];
}

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void updateEmail(String email) {
    state = state.copyWith(
      email: email,
      errorMessage: null,
    ); // Limpia error al tipear
  }

  void updatePassword(String password) {
    state = state.copyWith(
      password: password,
      errorMessage: null,
    ); // Limpia error al tipear
  }

  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  Future<void> login() async {
    if (!state.isValid) return;

    state = state.clearError().copyWith(isLoading: true);

    final authRepository = ref.read(authRepositoryProvider);

    final result = await authRepository.signInWithEmailAndPassword(
      email: state.email,
      password: state.password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (user) {
        // Apagas la carga
        state = state.copyWith(isLoading: false);
        // ej: ref.read(sessionProvider.notifier).setUser(user);
      },
    );
  }
}

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);
