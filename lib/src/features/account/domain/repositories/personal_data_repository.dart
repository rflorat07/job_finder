import '../../../../utils/typedefs.dart';
import '../entities/entities.dart';

/// Contract for reading and persisting the user's personal data.
abstract class PersonalDataRepository {
  /// Fetches the current user's personal data from the backend.
  FutureEither<PersonalDataEntity> fetchPersonalData();

  /// Persists the editable fields of the given [data].
  FutureEitherVoid updatePersonalData(PersonalDataEntity data);
}
