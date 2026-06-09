import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../datasources/bookmarks_remote_datasource.dart';

/// Concrete implementation of [BookmarksRepository].
/// Handles error mapping using the Railway-Oriented pattern (Either).
class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksRemoteDataSource _remoteDataSource;

  BookmarksRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Set<String>>> getBookmarkedJobIds() async {
    try {
      final ids = await _remoteDataSource.getBookmarkedJobIds();
      return Right(ids.toSet());
    } catch (e) {
      return Left(ServerFailure('Failed to load bookmarks', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark(String jobId) async {
    try {
      await _remoteDataSource.addBookmark(jobId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to save bookmark', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String jobId) async {
    try {
      await _remoteDataSource.removeBookmark(jobId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to remove bookmark', error: e));
    }
  }
}
