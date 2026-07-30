import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

/// Lifecycle states of the Manage Profile flow.
enum ProfileState { loading, loaded, saving, error }

/// Shared ViewModel that orchestrates loading the aggregate profile and saving
/// each editable section.
///
/// A single instance is created by the Manage Profile hub and passed down to
/// every edit sub-screen, so edits are reflected instantly across the flow
/// without refetching.
class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileViewModel(this._repository);

  ProfileState _state = ProfileState.loading;
  ProfileEntity? _profile;
  String? _errorMessage;
  bool _disposed = false;

  ProfileState get state => _state;
  ProfileEntity? get profile => _profile;
  String? get errorMessage => _errorMessage;

  bool get isSaving => _state == ProfileState.saving;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Loads the current user's aggregate profile.
  Future<void> loadProfile() async {
    if (_disposed) {
      return;
    }

    _state = ProfileState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.fetchProfile();
    if (_disposed) {
      return;
    }

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = ProfileState.error;
      },
      (profile) {
        _profile = profile;
        _state = ProfileState.loaded;
      },
    );

    notifyListeners();
  }

  /// Persists the "About Me" text. Returns `true` on success.
  Future<bool> saveAboutMe(String? aboutMe) {
    return _runSave(
      save: () => _repository.updateAboutMe(aboutMe),
      apply: (current) => current.copyWith(aboutMe: aboutMe),
    );
  }

  /// Persists the education section. Returns `true` on success.
  Future<bool> saveEducation({
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
  }) {
    return _runSave(
      save: () => _repository.updateEducation(
        educationLevel: educationLevel,
        school: school,
        studyProgram: studyProgram,
        educationStart: educationStart,
        graduateEducation: graduateEducation,
        organizationalExperience: organizationalExperience,
      ),
      apply: (current) => ProfileEntity(
        id: current.id,
        email: current.email,
        fullName: current.fullName,
        avatarUrl: current.avatarUrl,
        aboutMe: current.aboutMe,
        nickname: current.nickname,
        phoneNumber: current.phoneNumber,
        dateOfBirth: current.dateOfBirth,
        currentAddress: current.currentAddress,
        educationLevel: educationLevel,
        school: school,
        studyProgram: studyProgram,
        educationStart: educationStart,
        graduateEducation: graduateEducation,
        organizationalExperience: organizationalExperience,
        companyName: current.companyName,
        contractType: current.contractType,
        jobName: current.jobName,
        fieldOfWork: current.fieldOfWork,
        jobDescription: current.jobDescription,
        skills: current.skills,
        minimumSalary: current.minimumSalary,
      ),
    );
  }

  /// Persists the work experience section. Returns `true` on success.
  Future<bool> saveWorkExperience({
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
  }) {
    return _runSave(
      save: () => _repository.updateWorkExperience(
        companyName: companyName,
        contractType: contractType,
        jobName: jobName,
        fieldOfWork: fieldOfWork,
        jobDescription: jobDescription,
      ),
      apply: (current) => ProfileEntity(
        id: current.id,
        email: current.email,
        fullName: current.fullName,
        avatarUrl: current.avatarUrl,
        aboutMe: current.aboutMe,
        nickname: current.nickname,
        phoneNumber: current.phoneNumber,
        dateOfBirth: current.dateOfBirth,
        currentAddress: current.currentAddress,
        educationLevel: current.educationLevel,
        school: current.school,
        studyProgram: current.studyProgram,
        educationStart: current.educationStart,
        graduateEducation: current.graduateEducation,
        organizationalExperience: current.organizationalExperience,
        companyName: companyName,
        contractType: contractType,
        jobName: jobName,
        fieldOfWork: fieldOfWork,
        jobDescription: jobDescription,
        skills: current.skills,
        minimumSalary: current.minimumSalary,
      ),
    );
  }

  /// Persists the mastered skills. Returns `true` on success.
  Future<bool> saveSkills(List<String> skills) {
    return _runSave(
      save: () => _repository.updateSkills(skills),
      apply: (current) => current.copyWith(skills: skills),
    );
  }

  /// Persists the minimum salary. Returns `true` on success.
  Future<bool> saveSalary(int? minimumSalary) {
    return _runSave(
      save: () => _repository.updateSalary(minimumSalary),
      apply: (current) => ProfileEntity(
        id: current.id,
        email: current.email,
        fullName: current.fullName,
        avatarUrl: current.avatarUrl,
        aboutMe: current.aboutMe,
        nickname: current.nickname,
        phoneNumber: current.phoneNumber,
        dateOfBirth: current.dateOfBirth,
        currentAddress: current.currentAddress,
        educationLevel: current.educationLevel,
        school: current.school,
        studyProgram: current.studyProgram,
        educationStart: current.educationStart,
        graduateEducation: current.graduateEducation,
        organizationalExperience: current.organizationalExperience,
        companyName: current.companyName,
        contractType: current.contractType,
        jobName: current.jobName,
        fieldOfWork: current.fieldOfWork,
        jobDescription: current.jobDescription,
        skills: current.skills,
        minimumSalary: minimumSalary,
      ),
    );
  }

  /// Shared save pipeline: guards state, calls [save], and on success applies
  /// the optimistic [apply] transform to the cached profile.
  Future<bool> _runSave({
    required Future<Either<Failure, void>> Function() save,
    required ProfileEntity Function(ProfileEntity current) apply,
  }) async {
    final current = _profile;
    if (_disposed || current == null || _state == ProfileState.saving) {
      return false;
    }

    _state = ProfileState.saving;
    _errorMessage = null;
    notifyListeners();

    final result = await save();
    if (_disposed) {
      return false;
    }

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = ProfileState.loaded;
        notifyListeners();
        return false;
      },
      (_) {
        _profile = apply(current);
        _state = ProfileState.loaded;
        notifyListeners();
        return true;
      },
    );
  }
}
