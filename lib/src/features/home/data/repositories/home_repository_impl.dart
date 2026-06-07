import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/hot_vacancy_entity.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Concrete implementation of [HomeRepository].
/// Delegates to [HomeRemoteDataSource] and wraps results in [Either].
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<HotVacancyEntity>>> getHotVacancies() async {
    try {
      final models = await _remoteDataSource.getHotVacancies();
      return Right(models);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to load hot vacancies', error: e));
    }
  }

  @override
  Future<Either<Failure, List<JobListingEntity>>> getJobListings({
    String? jobType,
  }) async {
    try {
      final models = await _remoteDataSource.getJobListings(jobType: jobType);
      return Right(models);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to load job listings', error: e));
    }
  }
}
