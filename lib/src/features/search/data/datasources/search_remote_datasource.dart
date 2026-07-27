import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/data/models/job_listing_model.dart';

/// Contract for fetching Search data from an external source.
abstract class SearchRemoteDataSource {
  /// Runs a filtered, paginated query against `job_listings`.
  ///
  /// All parameters are already resolved primitives (no domain types),
  /// keeping this layer decoupled from the business rules.
  Future<List<JobListingModel>> searchJobs({
    String query = '',
    String? location,
    String? jobType,
    String? workMode,
    bool ascending = false,
    int limit = 20,
    int offset = 0,
  });

  /// Returns the distinct locations present in active job listings.
  Future<List<String>> fetchLocations();
}

/// Supabase implementation of [SearchRemoteDataSource].
class SupabaseSearchRemoteDataSource implements SearchRemoteDataSource {
  final SupabaseClient _client;

  SupabaseSearchRemoteDataSource(this._client);

  @override
  Future<List<JobListingModel>> searchJobs({
    String query = '',
    String? location,
    String? jobType,
    String? workMode,
    bool ascending = false,
    int limit = 20,
    int offset = 0,
  }) async {
    // Start from the base select; each filter narrows the result set.
    // We keep a PostgrestFilterBuilder until the final order/range calls,
    // because `.order()` transforms it into a transform builder.
    var builder = _client
        .from('job_listings')
        .select('*, companies(name, logo_url)');

    if (query.trim().isNotEmpty) {
      builder = builder.ilike('job_title', '%${query.trim()}%');
    }
    if (location != null && location.isNotEmpty) {
      builder = builder.ilike('location', '%$location%');
    }
    if (jobType != null) {
      builder = builder.eq('job_type', jobType);
    }
    if (workMode != null) {
      builder = builder.eq('work_mode', workMode);
    }

    final response = await builder
        .order('posted_at', ascending: ascending)
        .range(offset, offset + limit - 1);

    return response.map((json) => JobListingModel.fromJson(json)).toList();
  }

  @override
  Future<List<String>> fetchLocations() async {
    final response = await _client.from('job_listings').select('location');

    // Deduplicate and sort client-side (Postgres `distinct` is not exposed
    // by the query builder without an RPC).
    final locations = <String>{
      for (final row in response) row['location'] as String,
    };

    return locations.toList()..sort();
  }
}
