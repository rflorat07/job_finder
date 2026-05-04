import 'package:job_finder/src/imports/imports.dart';

import '../../domain/entities/entities.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;

  factory UserModel.empty() {
    return const UserModel(
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

extension UserModelMapper on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      profilePictureUrl: profilePictureUrl,
    );
  }
}
