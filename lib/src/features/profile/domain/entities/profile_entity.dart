/// Highest level of formal education completed by the user.
///
/// The [name] of each value is what gets stored in the Supabase
/// `profiles.education_level` column.
enum EducationLevel {
  highSchool,
  associate,
  bachelor,
  master,
  doctorate,
  other;

  /// Serializes the enum into the value persisted in Supabase.
  String get value => name;

  /// Parses a raw Supabase value into an [EducationLevel].
  ///
  /// Returns `null` when [raw] is `null` or does not match a known value.
  static EducationLevel? fromValue(String? raw) {
    if (raw == null) {
      return null;
    }
    for (final level in EducationLevel.values) {
      if (level.name == raw) {
        return level;
      }
    }
    return null;
  }
}

/// Employment contract type for the user's work experience.
///
/// The [name] of each value is what gets stored in the Supabase
/// `profiles.contract_type` column.
enum ContractType {
  fullTime,
  partTime,
  contract,
  internship,
  freelance;

  /// Serializes the enum into the value persisted in Supabase.
  String get value => name;

  /// Parses a raw Supabase value into a [ContractType].
  ///
  /// Returns `null` when [raw] is `null` or does not match a known value.
  static ContractType? fromValue(String? raw) {
    if (raw == null) {
      return null;
    }
    for (final type in ContractType.values) {
      if (type.name == raw) {
        return type;
      }
    }
    return null;
  }
}

/// Aggregate, immutable representation of the user's full public profile.
///
/// This entity backs the whole "Manage Profile" flow (About Me, Education,
/// Work Experience, Skills and Salary). The [email] is sourced from
/// `auth.users` and is therefore read-only; every other field lives in the
/// `profiles` table.
class ProfileEntity {
  // Identity / header
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;

  // About Me
  final String? aboutMe;

  // Personal data summary (edited from the Personal Data screen)
  final String? nickname;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? currentAddress;

  // Education
  final EducationLevel? educationLevel;
  final String? school;
  final String? studyProgram;
  final DateTime? educationStart;
  final DateTime? graduateEducation;
  final String? organizationalExperience;

  // Work Experience
  final String? companyName;
  final ContractType? contractType;
  final String? jobName;
  final String? fieldOfWork;
  final String? jobDescription;

  // Skills
  final List<String> skills;

  // Salary
  final int? minimumSalary;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.aboutMe,
    this.nickname,
    this.phoneNumber,
    this.dateOfBirth,
    this.currentAddress,
    this.educationLevel,
    this.school,
    this.studyProgram,
    this.educationStart,
    this.graduateEducation,
    this.organizationalExperience,
    this.companyName,
    this.contractType,
    this.jobName,
    this.fieldOfWork,
    this.jobDescription,
    this.skills = const [],
    this.minimumSalary,
  });

  /// Returns a copy of this entity with the provided fields replaced.
  ///
  /// Only the fields that can be edited from the Manage Profile flow are
  /// exposed here; identity fields ([id], [email]) are intentionally omitted.
  ProfileEntity copyWith({
    String? aboutMe,
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
    List<String>? skills,
    int? minimumSalary,
  }) {
    return ProfileEntity(
      id: id,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
      nickname: nickname,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      currentAddress: currentAddress,
      aboutMe: aboutMe ?? this.aboutMe,
      educationLevel: educationLevel ?? this.educationLevel,
      school: school ?? this.school,
      studyProgram: studyProgram ?? this.studyProgram,
      educationStart: educationStart ?? this.educationStart,
      graduateEducation: graduateEducation ?? this.graduateEducation,
      organizationalExperience:
          organizationalExperience ?? this.organizationalExperience,
      companyName: companyName ?? this.companyName,
      contractType: contractType ?? this.contractType,
      jobName: jobName ?? this.jobName,
      fieldOfWork: fieldOfWork ?? this.fieldOfWork,
      jobDescription: jobDescription ?? this.jobDescription,
      skills: skills ?? this.skills,
      minimumSalary: minimumSalary ?? this.minimumSalary,
    );
  }
}
