import '../../../../imports/imports.dart';
import '../../../../utils/utils.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalDatasource _localDatasource;

  AuthRepositoryImpl(this._localDatasource);

  @override
  FutureEither<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await _localDatasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) => Left(failure),
      (userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  FutureEither<User> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    LocalDatasource(),
  );
});
