import '../../../../utils/typedefs.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../entities/search_filters.dart';

/// Contract for the Search feature data operations.
///
/// Lives in the domain layer — it knows nothing about Supabase or JSON.
abstract class SearchRepository {
  /// Returns a paginated list of jobs matching the given [filters].
  ///
  /// [limit] restricts the number of results, [offset] handles pagination.
  FutureEither<List<JobListingEntity>> searchJobs({
    required SearchFilters filters,
    int limit = 20,
    int offset = 0,
  });

  /// Returns the distinct locations available in active job listings,
  /// used to populate the Location dropdown in the filter sheet.
  FutureEither<List<String>> fetchLocations();
}
