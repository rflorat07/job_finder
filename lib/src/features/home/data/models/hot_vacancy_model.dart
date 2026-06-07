import '../../domain/entities/hot_vacancy_entity.dart';

/// DTO that maps the Supabase `companies_with_open_jobs` VIEW response
/// into a [HotVacancyEntity].
class HotVacancyModel extends HotVacancyEntity {
  const HotVacancyModel({
    required super.id,
    required super.companyName,
    required super.openJobsCount,
    required super.logoUrl,
  });

  /// Creates a [HotVacancyModel] from a Supabase JSON row.
  ///
  /// Expected JSON shape (from `companies_with_open_jobs` VIEW):
  /// ```json
  /// {
  ///   "id": "uuid",
  ///   "company_name": "Stripe",
  ///   "logo_url": "https://...",
  ///   "open_jobs_count": 3
  /// }
  /// ```
  factory HotVacancyModel.fromJson(Map<String, dynamic> json) {
    return HotVacancyModel(
      id: json['id'] as String,
      companyName: json['company_name'] as String,
      openJobsCount: json['open_jobs_count'] as int,
      logoUrl: json['logo_url'] as String,
    );
  }
}
