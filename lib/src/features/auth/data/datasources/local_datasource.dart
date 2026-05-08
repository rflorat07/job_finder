import '../../../../imports/imports.dart';
import '../models/models.dart';

class LocalDatasource {
  FutureEither<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));

      if (email != 'test@test.com') {
        return const Left(ServerFailure('Credenciales incorrectas'));
      }

      final user = UserModel(
        id: '1',
        email: email,
        name: 'John Doe',
        profilePictureUrl: 'https://example.com/profile.jpg',
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Error de servidor: ${e.toString()}'));
    }
  }
}
