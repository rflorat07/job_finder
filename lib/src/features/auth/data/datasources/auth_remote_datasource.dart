import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

/// Defines the contract for external authentication data operations.
abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> signOut();
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
  Stream<bool> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session != null);
}
