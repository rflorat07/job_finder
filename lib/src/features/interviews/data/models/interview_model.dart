import '../../domain/entities/interview_entity.dart';

/// DTO for `interviews` table rows (JSON ↔ Dart).
class InterviewModel extends InterviewEntity {
  const InterviewModel({
    required super.id,
    required super.roleTitle,
    required super.companyName,
    required super.companyLogoUrl,
    required super.scheduledAt,
    required super.media,
    required super.status,
  });

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      id: json['id'] as String,
      roleTitle: json['role_title'] as String,
      companyName: json['company_name'] as String,
      companyLogoUrl: json['company_logo_url'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      media: json['media'] as String,
      status: _statusFromName(json['status'] as String?),
    );
  }

  /// Maps the database string into the domain [InterviewStatus].
  /// Defaults to [InterviewStatus.history] for any unknown value.
  static InterviewStatus _statusFromName(String? raw) {
    return switch (raw) {
      'ongoing' => InterviewStatus.ongoing,
      _ => InterviewStatus.history,
    };
  }
}
