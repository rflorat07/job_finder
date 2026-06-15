import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

enum AccountState { loading, loaded, error, signingOut }

class AccountViewModel extends ChangeNotifier {
  final AccountRepository _repository;

  AccountViewModel(this._repository);

  AccountState _state = AccountState.loading;
  AccountProfileEntity? _profile;
  String? _errorMessage;

  AccountState get state => _state;
  AccountProfileEntity? get profile => _profile;
  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _state = AccountState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchProfile();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = AccountState.error;
      },
      (profile) {
        _profile = profile;
        _state = AccountState.loaded;
      },
    );

    notifyListeners();
  }

  Future<bool> logout() async {
    if (_state == AccountState.signingOut) {
      return false;
    }

    _state = AccountState.signingOut;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.signOut();

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = AccountState.loaded;
        notifyListeners();
        return false;
      },
      (_) {
        _state = AccountState.loaded;
        notifyListeners();
        return true;
      },
    );
  }
}
