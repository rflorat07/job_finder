import '../../../../utils/typedefs.dart';
import '../../../home/domain/entities/job_listing_entity.dart';

/// Contract that defines the data operations the Job Detail feature needs.
/// Lives in the domain layer — knows nothing about Supabase or JSON.
abstract class JobDetailRepository {
  /// Returns the full [JobListingEntity] for the given [id].
  FutureEither<JobListingEntity> getJobById(String id);
}
