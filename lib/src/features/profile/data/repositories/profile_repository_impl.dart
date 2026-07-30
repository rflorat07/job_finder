import 'package:fpdart/fpdart.dart';

import '../../../../utils/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

/// Default implementation of [ProfileRepository] backed by a remote source.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> fetchProfile() async {
    try {
      final data = await _remoteDataSource.fetchProfile();
      return Right(data);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to load profile', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> updateAboutMe(String? aboutMe) async {
    try {
      await _remoteDataSource.updateAboutMe(aboutMe);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update About Me', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> updateEducation({
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
  }) async {
    try {
      await _remoteDataSource.updateEducation(
        educationLevel: educationLevel,
        school: school,
        studyProgram: studyProgram,
        educationStart: educationStart,
        graduateEducation: graduateEducation,
        organizationalExperience: organizationalExperience,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update education', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkExperience({
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
  }) async {
    try {
      await _remoteDataSource.updateWorkExperience(
        companyName: companyName,
        contractType: contractType,
        jobName: jobName,
        fieldOfWork: fieldOfWork,
        jobDescription: jobDescription,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update work experience', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> updateSkills(List<String> skills) async {
    try {
      await _remoteDataSource.updateSkills(skills);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update skills', error: e));
    }
  }

  @override
  Future<Either<Failure, void>> updateSalary(int? minimumSalary) async {
    try {
      await _remoteDataSource.updateSalary(minimumSalary);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure('Failed to update salary', error: e));
    }
  }
}
