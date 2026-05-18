class OfficialAccountEntity {
  final String id;
  final String name;
  final String logoUrl;
  final double followersCount;

  const OfficialAccountEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.followersCount = 0,
  });

  /// Mock data for official accounts
  static const List<OfficialAccountEntity> mocks = [
    OfficialAccountEntity(
      id: '1',
      name: 'Apple',
      logoUrl: 'assets/icons/apple.svg',
      followersCount: 9000,
    ),
    OfficialAccountEntity(
      id: '2',
      name: 'Amazon',
      logoUrl: 'assets/icons/amazon.svg',
      followersCount: 9000,
    ),
    OfficialAccountEntity(
      id: '3',
      name: 'Google',
      logoUrl: 'assets/icons/google.svg',
      followersCount: 9000,
    ),
    OfficialAccountEntity(
      id: '4',
      name: 'Netflix',
      logoUrl: 'assets/icons/netflix.svg',
      followersCount: 9000,
    ),
    OfficialAccountEntity(
      id: '5',
      name: 'Shopify',
      logoUrl: 'assets/icons/shopify.svg',
      followersCount: 9000,
    ),
  ];
}
