import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/data/models/job_listing_model.dart';

/// Contract for fetching Latest Jobs data from an external source.
abstract class LatestJobsRemoteDataSource {
  /// Fetches recent job listings with company info.
  /// [limit] restricts the number of results.
  /// [offset] for pagination.
  Future<List<JobListingModel>> fetchJobs({
    int limit = 50,
    int offset = 0,
  });
}

/// Supabase implementation of [LatestJobsRemoteDataSource].
class SupabaseLatestJobsRemoteDataSource implements LatestJobsRemoteDataSource {
  final SupabaseClient _client;

  SupabaseLatestJobsRemoteDataSource(this._client);

  @override
  Future<List<JobListingModel>> fetchJobs({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client
        .from('job_listings')
        .select('*, companies(name, logo_url)')
        .order('posted_at', ascending: false)
        .range(offset, offset + limit - 1);

    return response.map((json) => JobListingModel.fromJson(json)).toList();
  }
}
