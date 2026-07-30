import '../../domain/entities/entities.dart';

/// Data Transfer Object that maps a `profiles` row (plus the auth email) to a
/// [ProfileEntity] and back into the section-scoped JSON updates.
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.avatarUrl,
    super.aboutMe,
    super.nickname,
    super.phoneNumber,
    super.dateOfBirth,
    super.currentAddress,
    super.educationLevel,
    super.school,
    super.studyProgram,
    super.educationStart,
    super.graduateEducation,
    super.organizationalExperience,
    super.companyName,
    super.contractType,
    super.jobName,
    super.fieldOfWork,
    super.jobDescription,
    super.skills,
    super.minimumSalary,
  });

  /// Builds a model from a Supabase `profiles` row.
  ///
  /// [email] is provided separately because it lives in `auth.users`, not in
  /// the `profiles` table.
  factory ProfileModel.fromJson(
    Map<String, dynamic> json, {
    required String email,
  }) {
    final rawFullName = json['full_name'] as String?;

    return ProfileModel(
      id: json['id'] as String,
      email: email,
      fullName: (rawFullName?.trim().isNotEmpty ?? false) ? rawFullName! : '',
      avatarUrl: json['avatar_url'] as String?,
      aboutMe: json['bio'] as String?,
      nickname: json['nickname'] as String?,
      phoneNumber: json['phone_number'] as String?,
      dateOfBirth: _parseDate(json['date_of_birth'] as String?),
      currentAddress: json['current_address'] as String?,
      educationLevel: EducationLevel.fromValue(
        json['education_level'] as String?,
      ),
      school: json['school'] as String?,
      studyProgram: json['study_program'] as String?,
      educationStart: _parseDate(json['education_start'] as String?),
      graduateEducation: _parseDate(json['graduate_education'] as String?),
      organizationalExperience: json['organizational_experience'] as String?,
      companyName: json['company_name'] as String?,
      contractType: ContractType.fromValue(json['contract_type'] as String?),
      jobName: json['job_name'] as String?,
      fieldOfWork: json['field_of_work'] as String?,
      jobDescription: json['job_description'] as String?,
      skills: _parseStringList(json['skills']),
      minimumSalary: (json['minimum_salary'] as num?)?.toInt(),
    );
  }

  /// Serializes the "About Me" column for a Supabase `update`.
  static Map<String, dynamic> aboutMeUpdate(String? aboutMe) {
    return {'bio': aboutMe};
  }

  /// Serializes the education columns for a Supabase `update`.
  static Map<String, dynamic> educationUpdate({
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
  }) {
    return {
      'education_level': educationLevel?.value,
      'school': school,
      'study_program': studyProgram,
      'education_start': _formatDate(educationStart),
      'graduate_education': _formatDate(graduateEducation),
      'organizational_experience': organizationalExperience,
    };
  }

  /// Serializes the work experience columns for a Supabase `update`.
  static Map<String, dynamic> workExperienceUpdate({
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
  }) {
    return {
      'company_name': companyName,
      'contract_type': contractType?.value,
      'job_name': jobName,
      'field_of_work': fieldOfWork,
      'job_description': jobDescription,
    };
  }

  /// Serializes the skills column for a Supabase `update`.
  static Map<String, dynamic> skillsUpdate(List<String> skills) {
    return {'skills': skills};
  }

  /// Serializes the minimum salary column for a Supabase `update`.
  static Map<String, dynamic> salaryUpdate(int? minimumSalary) {
    return {'minimum_salary': minimumSalary};
  }

  /// Parses a Supabase `DATE` string into a [DateTime].
  static DateTime? _parseDate(String? raw) {
    if (raw == null) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  /// Formats a [DateTime] into the ISO `yyyy-MM-dd` string a `DATE` expects.
  static String? _formatDate(DateTime? date) {
    return date?.toIso8601String().split('T').first;
  }

  /// Safely maps a raw Supabase `TEXT[]` value into a `List<String>`.
  static List<String> _parseStringList(dynamic raw) {
    if (raw is List) {
      return raw.map((item) => item.toString()).toList();
    }
    return const [];
  }
}
