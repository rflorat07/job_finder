import '../../domain/entities/entities.dart';

/// Data Transfer Object that maps the `profiles` row (plus the auth email)
/// to a [PersonalDataEntity] and back.
class PersonalDataModel extends PersonalDataEntity {
  const PersonalDataModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.nickname,
    super.phoneNumber,
    super.dateOfBirth,
    super.gender,
    super.currentAddress,
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
      nickname: json['nickname'] as String?,
      phoneNumber: json['phone_number'] as String?,
      dateOfBirth: rawDateOfBirth != null
          ? DateTime.tryParse(rawDateOfBirth)
          : null,
      gender: Gender.fromValue(json['gender'] as String?),
      currentAddress: json['current_address'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Creates a model from a domain entity for persistence.
  factory PersonalDataModel.fromEntity(PersonalDataEntity entity) {
    return PersonalDataModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      nickname: entity.nickname,
      phoneNumber: entity.phoneNumber,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      currentAddress: entity.currentAddress,
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
      'nickname': nickname,
      'phone_number': phoneNumber,
      // Supabase `DATE` columns expect an ISO `yyyy-MM-dd` string.
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'gender': gender?.value,
      'current_address': currentAddress,
    };
  }
}
