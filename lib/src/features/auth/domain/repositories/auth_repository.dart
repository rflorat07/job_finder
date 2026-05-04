import 'package:job_finder/src/features/auth/domain/entities/user.dart';

import '../../../../utils/utils.dart';

abstract class AuthRepository {
  FutureEither<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  FutureEither<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
