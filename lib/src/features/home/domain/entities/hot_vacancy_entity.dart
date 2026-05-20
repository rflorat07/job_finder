class HotVacancyEntity {
  final String id;
  final String companyName;
  final int openJobsCount;
  final String logoUrl;

  const HotVacancyEntity({
    required this.id,
    required this.companyName,
    required this.openJobsCount,
    required this.logoUrl,
  });

  /// Mock data basada en tu diseño
  static const List<HotVacancyEntity> mocks = [
    HotVacancyEntity(
      id: '1',
      companyName: 'Stripe',
      openJobsCount: 8,
      logoUrl:
          'assets/icons/apple.svg', // Temporal hasta que tengamos el SVG de Stripe
    ),
    HotVacancyEntity(
      id: '2',
      companyName: 'Shopify',
      openJobsCount: 8,
      logoUrl: 'assets/icons/shopify.svg',
    ),
    HotVacancyEntity(
      id: '3',
      companyName: 'Meta',
      openJobsCount: 8,
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Meta_Platforms_Inc._logo.svg/1024px-Meta_Platforms_Inc._logo.svg.png',
    ),
    HotVacancyEntity(
      id: '4',
      companyName: 'Pinterest',
      openJobsCount: 5,
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/145/145808.png',
    ),
  ];
}
