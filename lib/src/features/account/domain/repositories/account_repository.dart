import '../../../../utils/typedefs.dart';
import '../entities/entities.dart';

abstract class AccountRepository {
  FutureEither<AccountProfileEntity> fetchProfile();

  FutureEitherVoid signOut();
}
