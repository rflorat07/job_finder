import '../entities/entities.dart';

abstract class AuthRepository {
  /// Registers a new user with the provided email and password.
  /// Returns the user ID upon successful registration.
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Authenticates an existing user using email and password.
  /// Returns the user ID upon successful login.
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Signs out the currently authenticated user.
  Future<void> signOut();

  /// A stream that emits true if the user is signed in, false otherwise.
  /// Useful for listening to auth state changes at app startup.
  Stream<bool> get authStateChanges;
}
