import 'package:flutter/material.dart';

import '../../domain/entities/hot_vacancy_entity.dart';

/// Possible states for the Home screen.
enum HomeState { loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  HomeState _state = HomeState.loading;
  String? _errorMessage;
  List<HotVacancyEntity> _hotVacancies = [];

  /// Current screen state.
  HomeState get state => _state;

  /// Error message (only relevant when [state] == [HomeState.error]).
  String? get errorMessage => _errorMessage;

  /// Public unmodifiable list so the UI reads state safely.
  List<HotVacancyEntity> get hotVacancies => List.unmodifiable(_hotVacancies);

  /// Loads Home data. Will connect to Supabase in the future.
  Future<void> fetchHomeData() async {
    _state = HomeState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with real repository / Supabase call
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _hotVacancies = List.from(HotVacancyEntity.mocks);
      _state = HomeState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeState.error;
    }

    notifyListeners();
  }
}
