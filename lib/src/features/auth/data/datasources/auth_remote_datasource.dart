import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

/// Defines the contract for external authentication data operations.
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> signOut();
  Future<void> sendOtpToEmail(String email);
  Future<UserModel> verifyEmailOtp(String email, String token);
  Stream<bool> get authStateChanges;
}

/// Supabase concrete implementation of the AuthRemoteDataSource.
/// ONLY this class talks directly to Supabase.
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<UserModel> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) throw Exception('User not found');
    return UserModel.fromSupabase(response.user!);
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) throw Exception('Registration failed');
    return UserModel.fromSupabase(response.user!);
  }

  @override
  Future<void> signOut() async => await _client.auth.signOut();

  @override
  Future<void> sendOtpToEmail(String email) async {
    await _client.auth.signInWithOtp(email: email);
  }

  @override
  Future<UserModel> verifyEmailOtp(String email, String token) async {
    // We specify OtpType.email to tell Supabase we are validating a 6-digit pin from email
    final response = await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    );
    if (response.user == null)
      throw Exception('Verification failed. Invalid or expired token.');
    return UserModel.fromSupabase(response.user!);
  }

  @override
  Stream<bool> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session != null);
}
