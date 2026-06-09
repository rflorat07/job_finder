import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../../latest_jobs/domain/repositories/latest_jobs_repository.dart';

/// Possible states for the Trending Jobs screen.
enum TrendingJobsState { loading, loaded, empty, error }

/// Page size used for paginated fetches.
const int _kPageSize = 20;

/// ViewModel for Trending Jobs feature.
/// Reuses [LatestJobsRepository] since it queries the same data.
class TrendingJobsViewModel extends ChangeNotifier {
  final LatestJobsRepository _repository;

  TrendingJobsViewModel(this._repository);

  TrendingJobsState _state = TrendingJobsState.loading;
  String? _errorMessage;
  List<JobListingEntity> _jobs = [];
  int _offset = 0;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  /// Current screen state.
  TrendingJobsState get state => _state;

  /// Error message (only relevant when [state] == [TrendingJobsState.error]).
  String? get errorMessage => _errorMessage;

  /// Public unmodifiable list of job listings.
  List<JobListingEntity> get jobs => List.unmodifiable(_jobs);

  /// Whether more jobs can be loaded.
  bool get canLoadMore => _hasMoreData && !_isLoadingMore;

  /// Whether a "load more" request is currently in progress.
  bool get isLoadingMore => _isLoadingMore;

  /// Loads initial batch of trending jobs.
  Future<void> loadJobs() async {
    _state = TrendingJobsState.loading;
    _offset = 0;
    _hasMoreData = true;
    _errorMessage = null;
    notifyListeners();

    final Either<Failure, List<JobListingEntity>> result = await _repository
        .fetchJobs(limit: _kPageSize, offset: _offset);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = TrendingJobsState.error;
      },
      (List<JobListingEntity> jobs) {
        _jobs = jobs;
        _hasMoreData = jobs.length >= _kPageSize;
        _state = jobs.isEmpty
            ? TrendingJobsState.empty
            : TrendingJobsState.loaded;
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
