import '../../domain/entities/setup_payload_entity.dart';

class SetupPayloadModel extends SetupPayloadEntity {
  const SetupPayloadModel({
    required super.countryCode,
    required super.expertiseIds,
    required super.officialAccountIds,
    required super.fullName,
    required super.username,
    required super.bio,
    super.avatarUrl,
  });

  factory SetupPayloadModel.fromEntity(SetupPayloadEntity entity) {
    return SetupPayloadModel(
      countryCode: entity.countryCode,
      expertiseIds: entity.expertiseIds,
      officialAccountIds: entity.officialAccountIds,
      fullName: entity.fullName,
      username: entity.username,
      bio: entity.bio,
      avatarUrl: entity.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      // For Supabase array columns, we can pass lists directly
      'expertises': expertiseIds,
      'official_accounts': officialAccountIds,
      'full_name': fullName,
      'username': username,
      'bio': bio,
      'setup_completed': true, // Marcar que el usuario terminó el onboarding
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };
  }
}
