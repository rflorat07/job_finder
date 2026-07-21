import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/interview_entity.dart';
import '../../domain/repositories/interview_repository.dart';
import '../datasources/interviews_remote_datasource.dart';

/// Concrete implementation of [InterviewRepository].
/// Orchestrates the datasource and maps low-level errors into [Failure]s.
class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewsRemoteDataSource _remoteDataSource;

  InterviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<InterviewEntity>>> fetchInterviews() async {
    try {
      final models = await _remoteDataSource.fetchInterviews();
      return Right(models);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to fetch interviews', error: e));
    }
  }
}
