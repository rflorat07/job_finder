/// Represents a job listing from the `job_listings` table.
///
/// Used by both "Best Matches" and "Most Recent" sections — same data,
/// different queries (filtered vs ordered by date).
class JobListingEntity {
  final String id;
  final String jobTitle;
  final String companyName;
  final String companyLogoUrl;
  final String location;
  final String salary;
  final String? description;
  final String workMode;
  final String jobType;

  /// Seniority level shown in the detail screen (e.g. "Senior").
  /// Nullable because not every listing specifies it.
  final String? experienceLevel;

  /// Bullet-point requirements shown in the detail screen.
  final List<String> qualifications;
  final List<String> tags;
  final DateTime postedAt;

  const JobListingEntity({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoUrl,
    required this.location,
    required this.salary,
    this.description,
    required this.workMode,
    required this.jobType,
    this.experienceLevel,
    this.qualifications = const [],
    required this.tags,
    required this.postedAt,
  });
}
