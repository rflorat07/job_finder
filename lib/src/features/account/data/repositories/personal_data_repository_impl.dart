import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

class PersonalDataRepositoryImpl implements PersonalDataRepository {
  final PersonalDataRemoteDataSource _remoteDataSource;

  PersonalDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PersonalDataEntity>> fetchPersonalData() async {
    try {
      final data = await _remoteDataSource.fetchPersonalData();
      return Right(data);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to load personal data', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> updatePersonalData(
    PersonalDataEntity data,
  ) async {
    try {
      await _remoteDataSource.updatePersonalData(
        PersonalDataModel.fromEntity(data),
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update personal data', error: e));
    }
  }
}
