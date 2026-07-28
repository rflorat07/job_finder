import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

/// Lifecycle states of the personal data screen.
enum PersonalDataState { loading, loaded, saving, error }

/// ViewModel that orchestrates loading and saving the user's personal data.
class PersonalDataViewModel extends ChangeNotifier {
  final PersonalDataRepository _repository;

  PersonalDataViewModel(this._repository);

  PersonalDataState _state = PersonalDataState.loading;
  PersonalDataEntity? _data;
  String? _errorMessage;
  bool _disposed = false;

  PersonalDataState get state => _state;
  PersonalDataEntity? get data => _data;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Loads the current user's personal data.
  Future<void> loadPersonalData() async {
    if (_disposed) {
      return;
    }

    _state = PersonalDataState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchPersonalData();
    if (_disposed) {
      return;
    }

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = PersonalDataState.error;
      },
      (data) {
        _data = data;
        _state = PersonalDataState.loaded;
      },
    );

    notifyListeners();
  }

  /// Persists the edited fields and returns `true` on success.
  Future<bool> save({
    required String fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Gender? gender,
  }) async {
    final current = _data;
    if (_disposed || current == null || _state == PersonalDataState.saving) {
      return false;
    }

    _state = PersonalDataState.saving;
    _errorMessage = null;
    notifyListeners();

    final updated = PersonalDataEntity(
      id: current.id,
      email: current.email,
      avatarUrl: current.avatarUrl,
      fullName: fullName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );

    final result = await _repository.updatePersonalData(updated);
    if (_disposed) {
      return false;
    }

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = PersonalDataState.loaded;
        notifyListeners();
        return false;
      },
      (_) {
        _data = updated;
        _state = PersonalDataState.loaded;
        notifyListeners();
        return true;
      },
    );
  }
}
