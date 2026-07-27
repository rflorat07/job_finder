import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/repositories/job_detail_repository.dart';
import '../datasources/job_detail_remote_datasource.dart';

/// Concrete implementation of [JobDetailRepository].
/// Delegates to [JobDetailRemoteDataSource] and wraps results in [Either].
class JobDetailRepositoryImpl implements JobDetailRepository {
  final JobDetailRemoteDataSource _remoteDataSource;

  JobDetailRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, JobListingEntity>> getJobById(String id) async {
    try {
      final model = await _remoteDataSource.getJobById(id);
      return Right(model);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to load job detail', error: e));
    }
  }
}
