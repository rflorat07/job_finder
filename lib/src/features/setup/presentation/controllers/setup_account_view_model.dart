import 'package:flutter/material.dart';

import '../../domain/entities/country_entity.dart';
import '../../domain/entities/expertise_entity.dart';

class SetupAccountViewModel extends ChangeNotifier {
  final int totalSteps = 4;

  // Step 1: Selected country state
  CountryEntity? _selectedCountry;

  // Step 2: Selected expertise categories
  final List<ExpertiseEntity> _selectedExpertises = [];

  CountryEntity? get selectedCountry => _selectedCountry;

  /// Returns a read-only list of selected expertises
  List<ExpertiseEntity> get selectedExpertises =>
      List.unmodifiable(_selectedExpertises);

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
}
