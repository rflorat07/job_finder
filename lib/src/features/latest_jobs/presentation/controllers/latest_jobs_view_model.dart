import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../../domain/repositories/latest_jobs_repository.dart';

/// Possible states for the Latest Jobs screen.
enum LatestJobsState { loading, loaded, empty, error }

/// Page size used for paginated fetches.
const int _kPageSize = 20;

/// ViewModel for Latest Jobs feature.
/// Manages state, fetches data, bookmarks, and exposes getters for the UI.
class LatestJobsViewModel extends ChangeNotifier {
  final LatestJobsRepository _repository;
  final BookmarksRepository _bookmarksRepository;

  LatestJobsViewModel(this._repository, this._bookmarksRepository);

  LatestJobsState _state = LatestJobsState.loading;
  String? _errorMessage;
  List<JobListingEntity> _jobs = [];
  int _offset = 0;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  /// Set of bookmarked job IDs for fast lookup.
  final Set<String> _bookmarkedIds = {};

  /// Current screen state.
  LatestJobsState get state => _state;

  /// Error message (only relevant when [state] == [LatestJobsState.error]).
  String? get errorMessage => _errorMessage;

  /// Public unmodifiable list of job listings.
  List<JobListingEntity> get jobs => List.unmodifiable(_jobs);

  /// Whether more jobs can be loaded (server returned a full page last time).
  bool get canLoadMore => _hasMoreData && !_isLoadingMore;

  /// Whether a "load more" request is currently in progress.
  bool get isLoadingMore => _isLoadingMore;

  /// Returns true if the job with [jobId] is bookmarked.
  bool isBookmarked(String jobId) => _bookmarkedIds.contains(jobId);

  /// Loads initial batch of recent jobs and the user's bookmarks.
  Future<void> loadJobs() async {
    _state = LatestJobsState.loading;
    _offset = 0;
    _hasMoreData = true;
    _errorMessage = null;
    notifyListeners();

    // Fetch jobs and bookmarks in parallel with proper typing
    final Either<Failure, List<JobListingEntity>> jobsResult;
    final Either<Failure, Set<String>> bookmarksResult;

    (jobsResult, bookmarksResult) = await (
      _repository.fetchJobs(limit: _kPageSize, offset: _offset),
      _bookmarksRepository.getBookmarkedJobIds(),
    ).wait;

    // Process bookmarks (non-blocking — don't fail if bookmarks fail)
    bookmarksResult.fold(
      (_) {},
      (Set<String> ids) => _bookmarkedIds
        ..clear()
        ..addAll(ids),
    );

    // Process jobs
    jobsResult.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = LatestJobsState.error;
      },
      (List<JobListingEntity> jobs) {
        _jobs = jobs;
        _hasMoreData = jobs.length >= _kPageSize;
        _state = jobs.isEmpty ? LatestJobsState.empty : LatestJobsState.loaded;
      },
    );

    notifyListeners();
  }

  /// Loads the next page of jobs (infinite scroll).
  /// Appends to existing list rather than replacing.
  Future<void> loadMore() async {
    if (!canLoadMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _offset += _kPageSize;
    final result = await _repository.fetchJobs(
      limit: _kPageSize,
      offset: _offset,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _offset -= _kPageSize; // Revert offset on failure
      },
      (List<JobListingEntity> newJobs) {
        _jobs = [..._jobs, ...newJobs];
        _hasMoreData = newJobs.length >= _kPageSize;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Toggles the bookmark status for a given job.
  Future<void> toggleBookmark(String jobId) async {
    final wasBookmarked = _bookmarkedIds.contains(jobId);

    // Optimistic update — toggle immediately for snappy UI
    if (wasBookmarked) {
      _bookmarkedIds.remove(jobId);
    } else {
      _bookmarkedIds.add(jobId);
    }
    notifyListeners();

    // Persist to backend
    final result = wasBookmarked
        ? await _bookmarksRepository.removeBookmark(jobId)
        : await _bookmarksRepository.addBookmark(jobId);

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

  /// Refreshes the list (resets pagination and reloads).
  Future<void> refresh() async {
    await loadJobs();
  }
}
