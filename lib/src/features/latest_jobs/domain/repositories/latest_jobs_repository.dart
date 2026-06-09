import '../../../../utils/typedefs.dart';
import '../../../home/domain/entities/job_listing_entity.dart';

/// Contract that defines what data operations the Latest Jobs feature needs.
/// Lives in the domain layer — knows nothing about Supabase or JSON.
abstract class LatestJobsRepository {
  /// Returns a paginated list of recent job listings.
  /// [limit] restricts the number of results (default: 50).
  /// [offset] for pagination (default: 0).
  FutureEither<List<JobListingEntity>> fetchJobs({
    int limit = 50,
    int offset = 0,
  });
}
