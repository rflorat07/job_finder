import 'package:flutter/material.dart';

import '../../domain/entities/country_entity.dart';

class SetupAccountViewModel extends ChangeNotifier {
  // Step 1: Selected country state
  CountryEntity? _selectedCountry;

  CountryEntity? get selectedCountry => _selectedCountry;

  /// Checks if the first step (Country Selection) is valid
  bool get isStep1Valid => _selectedCountry != null;

  /// Updates the selected country and notifies the UI to re-render
  void selectCountry(CountryEntity country) {
    _selectedCountry = country;
    notifyListeners();
  }

  /// Clears the selection (optional, just in case)
  void clearCountry() {
    _selectedCountry = null;
    notifyListeners();
  }
}
