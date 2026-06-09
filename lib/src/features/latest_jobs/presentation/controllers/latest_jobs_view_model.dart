import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/repositories/latest_jobs_repository.dart';

/// Possible states for the Latest Jobs screen.
enum LatestJobsState { loading, loaded, empty, error }

/// Page size used for paginated fetches.
const int _kPageSize = 20;

/// ViewModel for Latest Jobs feature.
/// Manages job listing state and pagination.
/// Bookmark state is handled by the shared [BookmarksService].
class LatestJobsViewModel extends ChangeNotifier {
  final LatestJobsRepository _repository;

  LatestJobsViewModel(this._repository);

  LatestJobsState _state = LatestJobsState.loading;
  String? _errorMessage;
  List<JobListingEntity> _jobs = [];
  int _offset = 0;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

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

  /// Loads initial batch of recent jobs.
  Future<void> loadJobs() async {
    _state = LatestJobsState.loading;
    _offset = 0;
    _hasMoreData = true;
    _errorMessage = null;
    notifyListeners();

    final Either<Failure, List<JobListingEntity>> result = await _repository
        .fetchJobs(limit: _kPageSize, offset: _offset);

    result.fold(
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
        _offset -= _kPageSize;
      },
      (List<JobListingEntity> newJobs) {
        _jobs = [..._jobs, ...newJobs];
        _hasMoreData = newJobs.length >= _kPageSize;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Refreshes the list (resets pagination and reloads).
  Future<void> refresh() async {
    await loadJobs();
  }
}
