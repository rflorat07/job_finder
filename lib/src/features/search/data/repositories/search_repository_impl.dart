import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

/// Implementation of the [SearchRepository] contract.
///
/// Translates the [SearchFilters] value object into primitive query
/// parameters and applies railway-oriented error handling.
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<JobListingEntity>>> searchJobs({
    required SearchFilters filters,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final models = await _remoteDataSource.searchJobs(
        query: filters.query,
        location: filters.location,
        jobType: filters.jobType.dbValue,
        workMode: filters.workMode.dbValue,
        ascending: filters.sort.ascending,
        limit: limit,
        offset: offset,
      );
      // Models already extend JobListingEntity, so the cast is safe.
      return Right(models.map((model) => model as JobListingEntity).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to search jobs', error: e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> fetchLocations() async {
    try {
      final locations = await _remoteDataSource.fetchLocations();
      return Right(locations);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch locations', error: e));
    }
  }
}
