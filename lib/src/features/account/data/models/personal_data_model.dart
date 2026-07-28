import '../../domain/entities/entities.dart';

/// Data Transfer Object that maps the `profiles` row (plus the auth email)
/// to a [PersonalDataEntity] and back.
class PersonalDataModel extends PersonalDataEntity {
  const PersonalDataModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.dateOfBirth,
    super.gender,
    super.avatarUrl,
  });

  /// Builds a model from a Supabase `profiles` row.
  ///
  /// [email] is provided separately because it lives in `auth.users`, not in
  /// the `profiles` table.
  factory PersonalDataModel.fromJson(
    Map<String, dynamic> json, {
    required String email,
  }) {
    final rawFullName = json['full_name'] as String?;
    final rawDateOfBirth = json['date_of_birth'] as String?;

    return PersonalDataModel(
      id: json['id'] as String,
      email: email,
      fullName: (rawFullName?.trim().isNotEmpty ?? false) ? rawFullName! : '',
      phoneNumber: json['phone_number'] as String?,
      dateOfBirth: rawDateOfBirth != null
          ? DateTime.tryParse(rawDateOfBirth)
          : null,
      gender: Gender.fromValue(json['gender'] as String?),
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Creates a model from a domain entity for persistence.
  factory PersonalDataModel.fromEntity(PersonalDataEntity entity) {
    return PersonalDataModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      avatarUrl: entity.avatarUrl,
    );
  }

  /// Serializes only the editable columns for a Supabase `update`.
  ///
  /// [email] and [avatarUrl] are intentionally excluded because they are not
  /// editable from this screen.
  Map<String, dynamic> toUpdateJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      // Supabase `DATE` columns expect an ISO `yyyy-MM-dd` string.
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'gender': gender?.value,
    };
  }
}
