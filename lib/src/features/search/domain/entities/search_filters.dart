/// Job type options offered in the filter sheet.
///
/// Each value maps to the `job_type` column in `job_listings`
/// (see the `valid_job_type` CHECK constraint). [any] means "no filter".
enum JobTypeFilter {
  any(null, 'search.job_type_any'),
  fullTime('full-time', 'search.job_type_full_time'),
  partTime('part-time', 'search.job_type_part_time'),
  contract('contract', 'search.job_type_contract');

  const JobTypeFilter(this.dbValue, this.labelKey);

  /// Value stored in the database, or `null` when no filter should apply.
  final String? dbValue;

  /// Translation key used to render the option label.
  final String labelKey;
}

/// Work mode options offered in the filter sheet.
///
/// Each value maps to the `work_mode` column in `job_listings`
/// (see the `valid_work_mode` CHECK constraint). [any] means "no filter".
enum WorkModeFilter {
  any(null, 'search.work_mode_any'),
  remote('remote', 'search.work_mode_remote'),
  hybrid('hybrid', 'search.work_mode_hybrid'),
  onSite('on-site', 'search.work_mode_on_site');

  const WorkModeFilter(this.dbValue, this.labelKey);

  /// Value stored in the database, or `null` when no filter should apply.
  final String? dbValue;

  /// Translation key used to render the option label.
  final String labelKey;
}

/// Ordering options for the result list, applied to `posted_at`.
enum JobSort {
  newest(false, 'search.sort_newest'),
  oldest(true, 'search.sort_oldest');

  const JobSort(this.ascending, this.labelKey);

  /// Whether `posted_at` should be ordered ascending.
  final bool ascending;

  /// Translation key used to render the option label.
  final String labelKey;
}

/// Immutable value object describing the current search criteria.
///
/// It is consumed by the repository to build the Supabase query and by the
/// UI (filter sheet) to render the currently selected options.
class SearchFilters {
  /// Free-text query matched against `job_title` (case-insensitive).
  final String query;

  /// Selected location, matched against `location` (case-insensitive).
  /// `null` means "all locations".
  final String? location;

  /// Selected job type.
  final JobTypeFilter jobType;

  /// Selected work mode.
  final WorkModeFilter workMode;

  /// Result ordering.
  final JobSort sort;

  const SearchFilters({
    this.query = '',
    this.location,
    this.jobType = JobTypeFilter.any,
    this.workMode = WorkModeFilter.any,
    this.sort = JobSort.newest,
  });

  /// Whether any of the dropdown filters (not the text query) is active.
  bool get hasActiveFilters =>
      location != null ||
      jobType != JobTypeFilter.any ||
      workMode != WorkModeFilter.any ||
      sort != JobSort.newest;

  /// Returns a copy with the given fields replaced.
  ///
  /// [clearLocation] is required to set [location] back to `null`, because a
  /// `null` argument alone cannot be distinguished from "keep the value".
  SearchFilters copyWith({
    String? query,
    String? location,
    bool clearLocation = false,
    JobTypeFilter? jobType,
    WorkModeFilter? workMode,
    JobSort? sort,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      location: clearLocation ? null : (location ?? this.location),
      jobType: jobType ?? this.jobType,
      workMode: workMode ?? this.workMode,
      sort: sort ?? this.sort,
    );
  }

  /// Returns a copy with every dropdown filter reset, keeping the text [query].
  SearchFilters cleared() => SearchFilters(query: query);
}
