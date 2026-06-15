class AccountProfileEntity {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? username;
  final String? bio;

  const AccountProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.username,
    this.bio,
  });
}
