import '../../domain/entities/job_listing_entity.dart';

/// DTO that maps the Supabase `job_listings JOIN companies` query response
/// into a [JobListingEntity].
class JobListingModel extends JobListingEntity {
  const JobListingModel({
    required super.id,
    required super.jobTitle,
    required super.companyName,
    required super.companyLogoUrl,
    required super.location,
    required super.salary,
    super.description,
    required super.workMode,
    required super.jobType,
    super.experienceLevel,
    super.qualifications,
    required super.tags,
    required super.postedAt,
  });

  /// Creates a [JobListingModel] from a Supabase JSON row.
  ///
  /// Expected JSON shape (from `job_listings` joined with `companies`):
  /// ```json
  /// {
  ///   "id": "uuid",
  ///   "job_title": "Senior Product Designer",
  ///   "location": "San Francisco, CA",
  ///   "salary": "$120k - $140k",
  ///   "description": "...",
  ///   "work_mode": "remote",
  ///   "job_type": "full-time",
  ///   "experience_level": "Senior",
  ///   "qualifications": ["3+ years experience", "Strong portfolio"],
  ///   "tags": ["Remote", "Full-time"],
  ///   "posted_at": "2026-06-05T10:00:00Z",
  ///   "companies": { "name": "Stripe", "logo_url": "https://..." }
  /// }
  /// ```
  factory JobListingModel.fromJson(Map<String, dynamic> json) {
    final company = json['companies'] as Map<String, dynamic>;

    return JobListingModel(
      id: json['id'] as String,
      jobTitle: json['job_title'] as String,
      companyName: company['name'] as String,
      companyLogoUrl: company['logo_url'] as String,
      location: json['location'] as String,
      salary: json['salary'] as String,
      description: json['description'] as String?,
      workMode: json['work_mode'] as String,
      jobType: json['job_type'] as String,
      experienceLevel: json['experience_level'] as String?,
      qualifications:
          (json['qualifications'] as List<dynamic>?)?.cast<String>() ??
          const [],
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      postedAt: DateTime.parse(json['posted_at'] as String),
    );
  }
}
