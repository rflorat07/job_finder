/// Represents a company with active job openings.
/// Used by the "Hot Vacancies" section in the Home screen.
class HotVacancyEntity {
  final String id;
  final String companyName;
  final int openJobsCount;
  final String logoUrl;

  const HotVacancyEntity({
    required this.id,
    required this.companyName,
    required this.openJobsCount,
    required this.logoUrl,
  });
}
