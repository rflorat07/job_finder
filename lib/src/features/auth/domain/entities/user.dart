import 'package:job_finder/src/imports/imports.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;

  factory User.empty() {
    return const User(
      id: '',
      name: '',
      email: '',
      profilePictureUrl: null,
    );
  }

  bool get isEmpty => id.isEmpty && name.isEmpty && email.isEmpty;

  @override
  List<Object?> get props => [id, name, email, profilePictureUrl];
}
