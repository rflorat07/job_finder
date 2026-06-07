import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/hot_vacancy_model.dart';
import '../models/job_listing_model.dart';

/// Contract for fetching Home screen data from an external source.
abstract class HomeRemoteDataSource {
  /// Fetches companies with active job counts from the
  /// `companies_with_open_jobs` VIEW.
  Future<List<HotVacancyModel>> getHotVacancies();

  /// Fetches job listings with company info.
  /// If [jobType] is provided, filters by that type (e.g. 'full-time').
  /// If [limit] is provided, restricts the number of results.
  Future<List<JobListingModel>> getJobListings({String? jobType, int? limit});
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

  @override
  Future<List<JobListingModel>> getJobListings({
    String? jobType,
    int? limit,
  }) async {
    var query = _client
        .from('job_listings')
        .select('*, companies(name, logo_url)');

    if (jobType != null) {
      query = query.eq('job_type', jobType);
    }

    final ordered = query.order('posted_at', ascending: false);

    final response = limit != null ? await ordered.limit(limit) : await ordered;

    return response.map((json) => JobListingModel.fromJson(json)).toList();
  }
}
