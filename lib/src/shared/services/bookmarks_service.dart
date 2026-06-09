import 'package:flutter/material.dart';

import '../../features/latest_jobs/domain/repositories/bookmarks_repository.dart';

/// Shared singleton service that manages bookmark state across the app.
/// Any ViewModel that needs bookmark info listens to this service.
class BookmarksService extends ChangeNotifier {
  final BookmarksRepository _repository;

  BookmarksService(this._repository);

  final Set<String> _bookmarkedIds = {};
  bool _isLoaded = false;

  /// Whether bookmarks have been loaded at least once.
  bool get isLoaded => _isLoaded;

  /// Returns true if the job with [jobId] is bookmarked.
  bool isBookmarked(String jobId) => _bookmarkedIds.contains(jobId);

  /// Loads all bookmarked job IDs from the backend.
  /// Safe to call multiple times — will reload from server each time.
  Future<void> loadBookmarks() async {
    final result = await _repository.getBookmarkedJobIds();

    result.fold(
      (_) {},
      (Set<String> ids) {
        _bookmarkedIds
          ..clear()
          ..addAll(ids);
        _isLoaded = true;
        notifyListeners();
      },
    );
  }

  /// Toggles the bookmark for [jobId] with optimistic update.
  /// Instantly updates all listeners, then persists to backend.
  /// Reverts automatically if the API call fails.
  Future<void> toggleBookmark(String jobId) async {
    final wasBookmarked = _bookmarkedIds.contains(jobId);

    // Optimistic update
    if (wasBookmarked) {
      _bookmarkedIds.remove(jobId);
    } else {
      _bookmarkedIds.add(jobId);
    }
    notifyListeners();

    // Persist
    final result = wasBookmarked
        ? await _repository.removeBookmark(jobId)
        : await _repository.addBookmark(jobId);

    // Revert on failure
    result.fold(
      (_) {
        if (wasBookmarked) {
          _bookmarkedIds.add(jobId);
        } else {
          _bookmarkedIds.remove(jobId);
        }
        notifyListeners();
      },
      (_) {},
    );
  }
}
