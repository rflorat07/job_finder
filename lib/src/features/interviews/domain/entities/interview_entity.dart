/// Whether an interview is currently scheduled/active or already finished.
enum InterviewStatus { ongoing, history }

/// Represents a scheduled interview shown in the Interviews feature.
///
/// Pure domain model with no framework or data-source dependency.
class InterviewEntity {
  final String id;
  final String roleTitle;
  final String companyName;
  final String companyLogoUrl;
  final DateTime scheduledAt;
  final String media;
  final String? meetingUrl;
  final InterviewStatus status;

  const InterviewEntity({
    required this.id,
    required this.roleTitle,
    required this.companyName,
    required this.companyLogoUrl,
    required this.scheduledAt,
    required this.media,
    this.meetingUrl,
    required this.status,
  });
}
