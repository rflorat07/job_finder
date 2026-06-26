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
  bool _disposed = false;

  AccountState get state => _state;
  AccountProfileEntity? get profile => _profile;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadProfile() async {
    if (_disposed) return;

    _state = AccountState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchProfile();
    if (_disposed) return;
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
    if (_disposed) return false;

    if (_state == AccountState.signingOut) {
      return false;
    }

    _state = AccountState.signingOut;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.signOut();
    if (_disposed) return false;

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
