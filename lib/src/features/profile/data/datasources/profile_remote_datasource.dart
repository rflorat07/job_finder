import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/entities.dart';
import '../models/models.dart';

/// Remote data source contract for the profile feature.
abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();

  Future<void> updateAboutMe(String? aboutMe);

  Future<void> updateEducation({
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
  });

  Future<void> updateWorkExperience({
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
  });

  Future<void> updateSkills(List<String> skills);

  Future<void> updateSalary(int? minimumSalary);
}

/// Supabase-backed implementation of [ProfileRemoteDataSource].
class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  final SupabaseClient _client;

  SupabaseProfileRemoteDataSource(this._client);

  /// Columns selected for the aggregate profile.
  static const String _selectColumns = '''
        id, full_name, avatar_url, bio, nickname, phone_number, date_of_birth,
        current_address, education_level, school, study_program,
        education_start, graduate_education, organizational_experience,
        company_name, contract_type, job_name, field_of_work, job_description,
        skills, minimum_salary
      ''';

  @override
  Future<ProfileModel> fetchProfile() async {
    final user = _requireUser();

    final profileMap = await _client
        .from('profiles')
        .select(_selectColumns)
        .eq('id', user.id)
        .single();

    return ProfileModel.fromJson(profileMap, email: user.email ?? '');
  }

  @override
  Future<void> updateAboutMe(String? aboutMe) {
    return _update(ProfileModel.aboutMeUpdate(aboutMe));
  }

  @override
  Future<void> updateEducation({
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
  }) {
    return _update(
      ProfileModel.educationUpdate(
        educationLevel: educationLevel,
        school: school,
        studyProgram: studyProgram,
        educationStart: educationStart,
        graduateEducation: graduateEducation,
        organizationalExperience: organizationalExperience,
      ),
    );
  }

  @override
  Future<void> updateWorkExperience({
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
  }) {
    return _update(
      ProfileModel.workExperienceUpdate(
        companyName: companyName,
        contractType: contractType,
        jobName: jobName,
        fieldOfWork: fieldOfWork,
        jobDescription: jobDescription,
      ),
    );
  }

  @override
  Future<void> updateSkills(List<String> skills) {
    return _update(ProfileModel.skillsUpdate(skills));
  }

  @override
  Future<void> updateSalary(int? minimumSalary) {
    return _update(ProfileModel.salaryUpdate(minimumSalary));
  }

  /// Applies a section-scoped [values] update to the current user's row.
  Future<void> _update(Map<String, dynamic> values) async {
    final user = _requireUser();
    await _client.from('profiles').update(values).eq('id', user.id);
  }

  /// Returns the authenticated user or throws when there is no session.
  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    return user;
  }
}
