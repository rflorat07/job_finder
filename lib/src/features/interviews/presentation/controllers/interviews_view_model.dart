import 'package:flutter/foundation.dart';

import '../../domain/entities/interview_entity.dart';
import '../../domain/repositories/interview_repository.dart';

/// Possible states for the Interviews screen.
enum InterviewsState { loading, loaded, empty, error }

/// Manages the Interviews screen state: the selected tab (Ongoing / History),
/// data loading via [InterviewRepository], and the list filtered by
/// [InterviewStatus].
///
/// Uses [ChangeNotifier] following the project's MVVM convention.
class InterviewsViewModel extends ChangeNotifier {
  final InterviewRepository _repository;

  InterviewsViewModel(this._repository);

  InterviewsState _state = InterviewsState.loading;
  String? _errorMessage;
  int _selectedTabIndex = 0;
  List<InterviewEntity> _interviews = [];

  /// Current screen state for the selected tab.
  InterviewsState get state => _state;

  /// Error message (only relevant when [state] == [InterviewsState.error]).
  String? get errorMessage => _errorMessage;

  /// Index of the currently selected tab (0 = Ongoing, 1 = History).
  int get selectedTabIndex => _selectedTabIndex;

  /// Status derived from the selected tab.
  InterviewStatus get _selectedStatus => _selectedTabIndex == 0
      ? InterviewStatus.ongoing
      : InterviewStatus.history;

  /// Interviews matching the currently selected tab.
  List<InterviewEntity> get interviews => List.unmodifiable(
    _interviews.where((interview) => interview.status == _selectedStatus),
  );

  /// Loads all interviews for the current user.
  Future<void> loadInterviews() async {
    _state = InterviewsState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchInterviews();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = InterviewsState.error;
      },
      (items) {
        _interviews = items;
        _resolveLoadedState();
      },
    );

    notifyListeners();
  }

  /// Updates the selected tab and refreshes the visible list.
  void selectTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    if (_state != InterviewsState.error) {
      _resolveLoadedState();
    }
    notifyListeners();
  }

  /// Sets [state] to empty or loaded based on the current tab's items.
  void _resolveLoadedState() {
    _state = interviews.isEmpty
        ? InterviewsState.empty
        : InterviewsState.loaded;
  }
}
