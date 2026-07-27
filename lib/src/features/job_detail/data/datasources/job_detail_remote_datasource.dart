import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../home/data/models/job_listing_model.dart';

/// Contract for fetching a single job listing from an external source.
abstract class JobDetailRemoteDataSource {
  /// Fetches one job listing (with its company info) by [id].
  Future<JobListingModel> getJobById(String id);
}

/// Supabase implementation of [JobDetailRemoteDataSource].
class SupabaseJobDetailRemoteDataSource implements JobDetailRemoteDataSource {
  final SupabaseClient _client;

  SupabaseJobDetailRemoteDataSource(this._client);

  @override
  Future<JobListingModel> getJobById(String id) async {
    final response = await _client
        .from('job_listings')
        .select('*, companies(name, logo_url)')
        .eq('id', id)
        .single();

    return JobListingModel.fromJson(response);
  }
}
