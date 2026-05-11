import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// The concrete implementation of the AuthRepository.
/// Orchestrates DataSources and catches lowest-level errors.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  // We inject the remote datasource so we can easily mock it in tests
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // In the future, you could check for network connectivity here before calling the datasource
    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signUp(email, password);
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Future<void> sendOtpToEmail({required String email}) async {
    return await remoteDataSource.sendOtpToEmail(email);
  }

  @override
  Future<UserEntity> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    return await remoteDataSource.verifyEmailOtp(email, token);
  }

  @override
  Stream<bool> get authStateChanges => remoteDataSource.authStateChanges;
}
