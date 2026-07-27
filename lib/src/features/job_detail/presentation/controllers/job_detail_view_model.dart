import 'package:flutter/material.dart';

import '../../../home/domain/entities/job_listing_entity.dart';
import '../../domain/repositories/job_detail_repository.dart';

/// Possible states for the Job Detail screen.
enum JobDetailState { loading, loaded, error }

/// ViewModel that loads a single job listing from Supabase and exposes it to
/// the [JobDetailScreen] via a simple state enum.
class JobDetailViewModel extends ChangeNotifier {
  final JobDetailRepository _repository;

  /// [initialJob] lets the screen render instantly with the data already
  /// available in the list, while the full record is (re)fetched from Supabase.
  JobDetailViewModel(this._repository, {JobListingEntity? initialJob})
    : _job = initialJob,
      _state = initialJob != null
          ? JobDetailState.loaded
          : JobDetailState.loading;

  JobDetailState _state;
  String? _errorMessage;
  JobListingEntity? _job;

  /// Current screen state.
  JobDetailState get state => _state;

  /// Error message (only relevant when [state] == [JobDetailState.error]).
  String? get errorMessage => _errorMessage;

  /// The loaded job listing, or `null` while loading/error.
  JobListingEntity? get job => _job;

  /// Loads the full job listing identified by [id] from Supabase.
  Future<void> loadJob(String id) async {
    // Keep showing existing data (if any) instead of a full-screen spinner.
    if (_job == null) {
      _state = JobDetailState.loading;
      notifyListeners();
    }

    final result = await _repository.getJobById(id);

    result.fold(
      (failure) {
        // Only surface the error if we have nothing to show.
        if (_job == null) {
          _errorMessage = failure.message;
          _state = JobDetailState.error;
        }
      },
      (job) {
        _job = job;
        _state = JobDetailState.loaded;
      },
    );

    notifyListeners();
  }
}
