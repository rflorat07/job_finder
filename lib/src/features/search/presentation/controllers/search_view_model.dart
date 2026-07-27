import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/search_repository.dart';

/// Possible states for the Search (Explore) screen.
enum SearchState { loading, loaded, empty, error }

/// Page size used for paginated fetches.
const int _kPageSize = 20;

/// Debounce applied to live text search to avoid a request per keystroke.
const Duration _kSearchDebounce = Duration(milliseconds: 350);

/// ViewModel for the Search feature.
///
/// Manages the current [SearchFilters], the result list with pagination,
/// and the available locations used by the filter sheet.
/// Bookmark state is handled by the shared `BookmarksService`.
class SearchViewModel extends ChangeNotifier {
  final SearchRepository _repository;

  SearchViewModel(this._repository);

  SearchState _state = SearchState.loading;
  String? _errorMessage;
  List<JobListingEntity> _jobs = [];
  SearchFilters _filters = const SearchFilters();
  List<String> _locations = [];

  int _offset = 0;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;
  Timer? _debounce;

  /// Current screen state.
  SearchState get state => _state;

  /// Error message (only relevant when [state] == [SearchState.error]).
  String? get errorMessage => _errorMessage;

  /// Public unmodifiable list of job results.
  List<JobListingEntity> get jobs => List.unmodifiable(_jobs);

  /// Currently applied filters (including the text query).
  SearchFilters get filters => _filters;

  /// Distinct locations available for the Location dropdown.
  List<String> get locations => List.unmodifiable(_locations);

  /// Whether a "load more" request is currently in progress.
  bool get isLoadingMore => _isLoadingMore;

  /// Whether more results can be loaded.
  bool get canLoadMore => _hasMoreData && !_isLoadingMore;

  /// Loads the initial results and the location options.
  Future<void> init() async {
    await Future.wait([_search(), _loadLocations()]);
  }

  /// Called on every keystroke; debounces before running the search.
  void onQueryChanged(String query) {
    _filters = _filters.copyWith(query: query);
    _debounce?.cancel();
    _debounce = Timer(_kSearchDebounce, _search);
  }

  /// Applies a new set of [filters] coming from the filter sheet.
  Future<void> applyFilters(SearchFilters filters) async {
    _filters = filters;
    await _search();
  }

  /// Re-runs the current search (used by pull-to-refresh and retry).
  Future<void> refresh() => _search();

  /// Runs the search from scratch, resetting pagination.
  Future<void> _search() async {
    _state = SearchState.loading;
    _offset = 0;
    _hasMoreData = true;
    _errorMessage = null;
    notifyListeners();

    final Either<Failure, List<JobListingEntity>> result = await _repository
        .searchJobs(filters: _filters, limit: _kPageSize, offset: _offset);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = SearchState.error;
      },
      (jobs) {
        _jobs = jobs;
        _hasMoreData = jobs.length >= _kPageSize;
        _state = jobs.isEmpty ? SearchState.empty : SearchState.loaded;
      },
    );

    notifyListeners();
  }

  /// Loads the next page of results (infinite scroll).
  Future<void> loadMore() async {
    if (!canLoadMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _offset += _kPageSize;
    final result = await _repository.searchJobs(
      filters: _filters,
      limit: _kPageSize,
      offset: _offset,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _offset -= _kPageSize;
      },
      (newJobs) {
        _jobs = [..._jobs, ...newJobs];
        _hasMoreData = newJobs.length >= _kPageSize;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Loads the distinct locations for the filter dropdown.
  Future<void> _loadLocations() async {
    final result = await _repository.fetchLocations();
    result.fold(
      (_) => _locations = const [],
      (locations) => _locations = locations,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
