import 'package:flutter/material.dart';

import '../../domain/entities/hot_vacancy_entity.dart';
import '../../domain/entities/job_match_entity.dart';
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
  List<JobMatchEntity> _allMatches = [];
  List<JobMatchEntity> _filteredMatches = [];
  List<RecentJobEntity> _recentJobs = [];
  JobFilter _selectedFilter = JobFilter.allJobs;

  /// Current screen state.
  HomeState get state => _state;

  /// Error message (only relevant when [state] == [HomeState.error]).
  String? get errorMessage => _errorMessage;

  /// Public unmodifiable list so the UI reads state safely.
  List<HotVacancyEntity> get hotVacancies => List.unmodifiable(_hotVacancies);

  /// Best matching jobs filtered by the current [selectedFilter].
  List<JobMatchEntity> get bestMatches => List.unmodifiable(_filteredMatches);

  /// Most recently posted jobs.
  List<RecentJobEntity> get recentJobs => List.unmodifiable(_recentJobs);

  /// Currently selected job filter.
  JobFilter get selectedFilter => _selectedFilter;

  /// Updates the selected filter and refreshes the visible list.
  void setFilter(JobFilter filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  /// Applies the current filter to the full matches list.
  void _applyFilter() {
    if (_selectedFilter == JobFilter.allJobs) {
      _filteredMatches = List.from(_allMatches);
      return;
    }

    final tagToMatch = switch (_selectedFilter) {
      JobFilter.allJobs => '',
      JobFilter.fullTime => 'Full-time',
      JobFilter.partTime => 'Part-time',
      JobFilter.freelance => 'Contract',
    };

    _filteredMatches = _allMatches
        .where((job) => job.tags.contains(tagToMatch))
        .toList();
  }

  /// Loads Home data from the repository.
  Future<void> fetchHomeData() async {
    _state = HomeState.loading;
    _errorMessage = null;
    notifyListeners();

    // Fetch hot vacancies from Supabase via repository
    final result = await _repository.getHotVacancies();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = HomeState.error;
      },
      (vacancies) {
        _hotVacancies = vacancies;

        // TODO: Replace with repository calls when ready
        _allMatches = List.from(JobMatchEntity.mocks);
        _recentJobs = List.from(RecentJobEntity.mocks);
        _applyFilter();
        _state = HomeState.loaded;
      },
    );

    notifyListeners();
  }
}
