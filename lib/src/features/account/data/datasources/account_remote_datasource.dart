import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

abstract class AccountRemoteDataSource {
  Future<AccountProfileModel> fetchProfile();

  Future<void> signOut();
}

class SupabaseAccountRemoteDataSource implements AccountRemoteDataSource {
  final SupabaseClient _client;

  SupabaseAccountRemoteDataSource(this._client);

  @override
  Future<AccountProfileModel> fetchProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final profileMap = await _client
        .from('profiles')
        .select('id, full_name, avatar_url, username, bio')
        .eq('id', user.id)
        .single();

    return AccountProfileModel.fromJson(
      profileMap,
      email: user.email ?? '',
    );
  }

  @override
  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
