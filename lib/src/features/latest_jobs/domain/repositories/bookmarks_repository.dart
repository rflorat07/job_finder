import '../../../../utils/typedefs.dart';

/// Contract for bookmark (saved jobs) operations.
/// The user can save/unsave job listings as favorites.
abstract class BookmarksRepository {
  /// Returns the set of job IDs that the current user has bookmarked.
  FutureEither<Set<String>> getBookmarkedJobIds();

  /// Adds a bookmark for the given [jobId].
  FutureEitherVoid addBookmark(String jobId);

  /// Removes the bookmark for the given [jobId].
  FutureEitherVoid removeBookmark(String jobId);
}
