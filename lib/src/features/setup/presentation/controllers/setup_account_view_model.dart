import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class SetupAccountViewModel extends ChangeNotifier {
  final int totalSteps = 4;

  // Step 1: Selected country state
  CountryEntity? _selectedCountry;

  // Step 2: Selected expertise categories
  final List<ExpertiseEntity> _selectedExpertises = [];

  // Step 3: Selected official accounts
  final List<OfficialAccountEntity> _selectedOfficialAccounts = [];

  /// Returns a read-only list of selected expertises
  List<ExpertiseEntity> get selectedExpertises =>
      List.unmodifiable(_selectedExpertises);

  /// Returns a read-only list of selected official accounts
  List<OfficialAccountEntity> get selectedOfficialAccounts =>
      List.unmodifiable(_selectedOfficialAccounts);

  /// Returns the currently selected country (or null if none)
  CountryEntity? get selectedCountry => _selectedCountry;

  /// Checks if the first step (Country Selection) is valid
  bool get isStep1Valid => _selectedCountry != null;

  /// Checks if the second step (Expertise Selection) is valid
  /// (e.g. at least 1, max 3)
  bool get isStep2Valid => _selectedExpertises.isNotEmpty;

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

  /// Toggles the selection of an expertise category
  void toggleExpertise(ExpertiseEntity expertise) {
    if (_selectedExpertises.contains(expertise)) {
      _selectedExpertises.remove(expertise);
    } else {
      // Optional constraint: Limit the number of selected expertises to 5
      if (_selectedExpertises.length < 5) {
        _selectedExpertises.add(expertise);
      }
    }
    notifyListeners();
  }

  /// Checks if a specific expertise is selected
  bool isExpertiseSelected(ExpertiseEntity expertise) {
    return _selectedExpertises.contains(expertise);
  }

  /// Toggles the selection of an official account
  void toggleOfficialAccount(OfficialAccountEntity officialAccount) {
    if (_selectedOfficialAccounts.contains(officialAccount)) {
      _selectedOfficialAccounts.remove(officialAccount);
    } else {
      _selectedOfficialAccounts.add(officialAccount);
    }
    notifyListeners();
  }

  /// Checks if a specific official account is selected
  bool isOfficialAccountSelected(OfficialAccountEntity officialAccount) {
    return _selectedOfficialAccounts.contains(officialAccount);
  }
}
