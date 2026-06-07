import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/hot_vacancy_model.dart';

/// Contract for fetching Home screen data from an external source.
abstract class HomeRemoteDataSource {
  /// Fetches companies with active job counts from the
  /// `companies_with_open_jobs` VIEW.
  Future<List<HotVacancyModel>> getHotVacancies();
}

/// Supabase implementation of [HomeRemoteDataSource].
class SupabaseHomeRemoteDataSource implements HomeRemoteDataSource {
  final SupabaseClient _client;

  SupabaseHomeRemoteDataSource(this._client);

  @override
  Future<List<HotVacancyModel>> getHotVacancies() async {
    final response = await _client.from('companies_with_open_jobs').select();

    return response.map((json) => HotVacancyModel.fromJson(json)).toList();
  }
}
