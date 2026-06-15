import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;

  AccountRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AccountProfileEntity>> fetchProfile() async {
    try {
      final profile = await _remoteDataSource.fetchProfile();
      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to load account profile', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to sign out', error: e));
    }
  }
}
