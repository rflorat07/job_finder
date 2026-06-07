import 'package:flutter/material.dart';

import '../../domain/entities/hot_vacancy_entity.dart';
import '../../domain/entities/job_listing_entity.dart';
import '../../domain/entities/recent_job_entity.dart';
import '../../domain/repositories/home_repository.dart';

/// Possible states for the Home screen.
enum HomeState { loading, loaded, error }

/// Available job type filters for Best Matches.
enum JobFilter { allJobs, fullTime, partTime, freelance }

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;

  HomeViewModel(this._repository);

  HomeState _state = HomeState.loading;
  String? _errorMessage;
  List<HotVacancyEntity> _hotVacancies = [];
  List<JobListingEntity> _bestMatches = [];
  List<RecentJobEntity> _recentJobs = [];
  JobFilter _selectedFilter = JobFilter.allJobs;

  /// Current screen state.
  HomeState get state => _state;

  /// Error message (only relevant when [state] == [HomeState.error]).
  String? get errorMessage => _errorMessage;

  /// Public unmodifiable list so the UI reads state safely.
  List<HotVacancyEntity> get hotVacancies => List.unmodifiable(_hotVacancies);

  /// Best matching jobs filtered by the current [selectedFilter].
  List<JobListingEntity> get bestMatches => List.unmodifiable(_bestMatches);

  /// Most recently posted jobs.
  List<RecentJobEntity> get recentJobs => List.unmodifiable(_recentJobs);

  /// Currently selected job filter.
  JobFilter get selectedFilter => _selectedFilter;

  /// Updates the selected filter and fetches filtered results from Supabase.
  Future<void> setFilter(JobFilter filter) async {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    await _fetchBestMatches();
    notifyListeners();
  }

  /// Maps a [JobFilter] enum to the Supabase `job_type` column value.
  String? _jobTypeForFilter(JobFilter filter) {
    return switch (filter) {
      JobFilter.allJobs => null,
      JobFilter.fullTime => 'full-time',
      JobFilter.partTime => 'part-time',
      JobFilter.freelance => 'contract',
    };
  }

  /// Fetches best matches from Supabase applying the current filter.
  Future<void> _fetchBestMatches() async {
    final jobType = _jobTypeForFilter(_selectedFilter);
    final result = await _repository.getJobListings(jobType: jobType);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = HomeState.error;
      },
      (listings) => _bestMatches = listings,
    );
  }

  /// Loads all Home data from the repository.
  Future<void> fetchHomeData() async {
    _state = HomeState.loading;
    _errorMessage = null;
    notifyListeners();

    // Fetch hot vacancies
    final vacanciesResult = await _repository.getHotVacancies();

    final failed = vacanciesResult.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = HomeState.error;
        return true;
      },
      (vacancies) {
        _hotVacancies = vacancies;
        return false;
      },
    );

    if (failed) {
      notifyListeners();
      return;
    }

    // Fetch best matches (job listings)
    await _fetchBestMatches();

    if (_state == HomeState.error) {
      notifyListeners();
      return;
    }

    // TODO: Replace with repository call when ready
    _recentJobs = List.from(RecentJobEntity.mocks);

    _state = HomeState.loaded;
    notifyListeners();
  }
}
