import '../../../../utils/typedefs.dart';
import '../entities/entities.dart';

/// Contract for reading and persisting the user's full profile.
///
/// Updates are exposed as granular, section-scoped methods so each edit screen
/// only touches the columns it owns and never clobbers unrelated data.
abstract class ProfileRepository {
  /// Fetches the current user's aggregate profile from the backend.
  FutureEither<ProfileEntity> fetchProfile();

  /// Persists the "About Me" text.
  FutureEitherVoid updateAboutMe(String? aboutMe);

  /// Persists the education section.
  FutureEitherVoid updateEducation({
    EducationLevel? educationLevel,
    String? school,
    String? studyProgram,
    DateTime? educationStart,
    DateTime? graduateEducation,
    String? organizationalExperience,
  });

  /// Persists the work experience section.
  FutureEitherVoid updateWorkExperience({
    String? companyName,
    ContractType? contractType,
    String? jobName,
    String? fieldOfWork,
    String? jobDescription,
  });

  /// Persists the user's mastered skills.
  FutureEitherVoid updateSkills(List<String> skills);

  /// Persists the minimum expected monthly salary.
  FutureEitherVoid updateSalary(int? minimumSalary);
}
