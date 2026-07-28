/// Gender options supported by the personal data form.
///
/// The [name] of each value matches the string stored in the Supabase
/// `profiles.gender` column (`male`, `female`, `other`).
enum Gender {
  male,
  female,
  other;

  /// Serializes the enum into the value persisted in Supabase.
  String get value => name;

  /// Parses a raw Supabase value into a [Gender].
  ///
  /// Returns `null` when [raw] is `null` or does not match a known value.
  static Gender? fromValue(String? raw) {
    if (raw == null) {
      return null;
    }
    for (final gender in Gender.values) {
      if (gender.name == raw) {
        return gender;
      }
    }
    return null;
  }
}

/// Immutable representation of the user's editable personal data.
///
/// The [email] is sourced from `auth.users` and is therefore read-only from
/// this screen; every other field lives in the `profiles` table.
class PersonalDataEntity {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? avatarUrl;

  const PersonalDataEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
  });
}
