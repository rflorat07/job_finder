import 'package:flutter/foundation.dart';

import '../../domain/entities/interview_entity.dart';

/// Manages the Interviews screen state: the selected tab (Ongoing / History)
/// and the interviews filtered by [InterviewStatus].
///
/// Uses [ChangeNotifier] following the project's MVVM convention.
class InterviewsViewModel extends ChangeNotifier {
  int _selectedTabIndex = 0;

  /// Index of the currently selected tab (0 = Ongoing, 1 = History).
  int get selectedTabIndex => _selectedTabIndex;

  /// Status derived from the selected tab.
  InterviewStatus get _selectedStatus => _selectedTabIndex == 0
      ? InterviewStatus.ongoing
      : InterviewStatus.history;

  /// Interviews matching the currently selected tab.
  List<InterviewEntity> get interviews => InterviewEntity.mockData
      .where((interview) => interview.status == _selectedStatus)
      .toList();

  /// Updates the selected tab and refreshes the visible list.
  void selectTab(int index) {
    if (_selectedTabIndex == index) return;
    _selectedTabIndex = index;
    notifyListeners();
  }
}
