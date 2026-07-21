/// Whether an interview is currently scheduled/active or already finished.
enum InterviewStatus { ongoing, history }

/// Represents a scheduled interview shown in the Interviews feature.
///
/// Holds mock data as a static list during prototyping (no backend yet).
class InterviewEntity {
  final String id;
  final String roleTitle;
  final String companyName;
  final String companyLogoUrl;
  final DateTime scheduledAt;
  final String media;
  final InterviewStatus status;

  const InterviewEntity({
    required this.id,
    required this.roleTitle,
    required this.companyName,
    required this.companyLogoUrl,
    required this.scheduledAt,
    required this.media,
    required this.status,
  });

  /// Mock interviews used while the backend is not connected yet.
  static final List<InterviewEntity> mockData = [
    InterviewEntity(
      id: '1',
      roleTitle: 'User Interface Designer',
      companyName: 'Pinterest',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/145/145808.png',
      scheduledAt: DateTime(2024, 12, 20, 11),
      media: 'Google Meet',
      status: InterviewStatus.ongoing,
    ),
    InterviewEntity(
      id: '2',
      roleTitle: 'Graphic Designer',
      companyName: 'Webflow',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/5968/5968672.png',
      scheduledAt: DateTime(2024, 12, 20, 11),
      media: 'Google Meet',
      status: InterviewStatus.ongoing,
    ),
    InterviewEntity(
      id: '3',
      roleTitle: 'Product Designer',
      companyName: 'Dribbble',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/2111/2111490.png',
      scheduledAt: DateTime(2024, 11, 5, 9, 30),
      media: 'Zoom',
      status: InterviewStatus.history,
    ),
    InterviewEntity(
      id: '4',
      roleTitle: 'Frontend Developer',
      companyName: 'GitHub',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/25/25231.png',
      scheduledAt: DateTime(2024, 10, 18, 14),
      media: 'Google Meet',
      status: InterviewStatus.history,
    ),
  ];
}
