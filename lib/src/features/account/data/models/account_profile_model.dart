import '../../domain/entities/entities.dart';

class AccountProfileModel extends AccountProfileEntity {
  const AccountProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.avatarUrl,
    super.username,
    super.bio,
  });

  factory AccountProfileModel.fromJson(
    Map<String, dynamic> json, {
    required String email,
  }) {
    return AccountProfileModel(
      id: json['id'] as String,
      fullName: (json['full_name'] as String?)?.trim().isNotEmpty ?? false
          ? (json['full_name'] as String)
          : 'User',
      email: email,
      avatarUrl: json['avatar_url'] as String?,
      username: json['username'] as String?,
      bio: json['bio'] as String?,
    );
  }
}
