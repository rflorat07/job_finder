import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/repositories/latest_jobs_repository.dart';
import '../datasources/latest_jobs_remote_datasource.dart';

/// Implementation of the [LatestJobsRepository] contract.
/// Handles the conversion from data models to domain entities
/// and applies railway-oriented error handling.
class LatestJobsRepositoryImpl implements LatestJobsRepository {
  final LatestJobsRemoteDataSource _remoteDataSource;

  LatestJobsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<JobListingEntity>>> fetchJobs({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final models = await _remoteDataSource.fetchJobs(
        limit: limit,
        offset: offset,
      );
      // Models already extend JobListingEntity, so casting is safe
      return Right(
        models.map((model) => model as JobListingEntity).toList(),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to fetch latest jobs', error: e));
    }
  }
}
