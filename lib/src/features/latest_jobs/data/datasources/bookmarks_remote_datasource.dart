import 'package:supabase_flutter/supabase_flutter.dart';

/// Contract for bookmark data operations against an external source.
abstract class BookmarksRemoteDataSource {
  /// Returns the list of job IDs bookmarked by the current user.
  Future<List<String>> getBookmarkedJobIds();

  /// Inserts a bookmark row for [jobId].
  Future<void> addBookmark(String jobId);

  /// Deletes the bookmark row for [jobId].
  Future<void> removeBookmark(String jobId);
}

/// Supabase implementation of [BookmarksRemoteDataSource].
/// Reads/writes from the `bookmarks` table.
class SupabaseBookmarksRemoteDataSource implements BookmarksRemoteDataSource {
  final SupabaseClient _client;

  SupabaseBookmarksRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<List<String>> getBookmarkedJobIds() async {
    final response = await _client
        .from('bookmarks')
        .select('job_listing_id')
        .eq('user_id', _userId);

    return response
        .map<String>((row) => row['job_listing_id'] as String)
        .toList();
  }

  @override
  Future<void> addBookmark(String jobId) async {
    await _client.from('bookmarks').insert({
      'user_id': _userId,
      'job_listing_id': jobId,
    });
  }

  @override
  Future<void> removeBookmark(String jobId) async {
    await _client
        .from('bookmarks')
        .delete()
        .eq('user_id', _userId)
        .eq('job_listing_id', jobId);
  }
}
