import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

/// Remote data source contract for the personal data feature.
abstract class PersonalDataRemoteDataSource {
  Future<PersonalDataModel> fetchPersonalData();

  Future<void> updatePersonalData(PersonalDataModel data);
}

/// Supabase-backed implementation of [PersonalDataRemoteDataSource].
class SupabasePersonalDataRemoteDataSource
    implements PersonalDataRemoteDataSource {
  final SupabaseClient _client;

  SupabasePersonalDataRemoteDataSource(this._client);

  @override
  Future<PersonalDataModel> fetchPersonalData() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final profileMap = await _client
        .from('profiles')
        .select(
          'id, full_name, phone_number, date_of_birth, gender, avatar_url',
        )
        .eq('id', user.id)
        .single();

    return PersonalDataModel.fromJson(
      profileMap,
      email: user.email ?? '',
    );
  }

  @override
  Future<void> updatePersonalData(PersonalDataModel data) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    await _client
        .from('profiles')
        .update(data.toUpdateJson())
        .eq('id', user.id);
  }
}
