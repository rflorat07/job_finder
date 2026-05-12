/// Represents a Country in the domain layer.
class CountryEntity {
  final String name;
  final String code;
  final String flagEmoji;

  const CountryEntity({
    required this.name,
    required this.code,
    required this.flagEmoji,
  });

  // A small mock list to work with immediately without an API.
  static const List<CountryEntity> mocks = [
    CountryEntity(name: 'United States', code: 'US', flagEmoji: '🇺🇸'),
    CountryEntity(name: 'United Kingdom', code: 'GB', flagEmoji: '🇬🇧'),
    CountryEntity(name: 'United Arab Emirates', code: 'AE', flagEmoji: '🇦🇪'),
    CountryEntity(name: 'Spain', code: 'ES', flagEmoji: '🇪🇸'),
    CountryEntity(name: 'Mexico', code: 'MX', flagEmoji: '🇲🇽'),
    CountryEntity(name: 'Canada', code: 'CA', flagEmoji: '🇨🇦'),
    CountryEntity(name: 'Italy', code: 'IT', flagEmoji: '🇮🇹'),
    CountryEntity(name: 'France', code: 'FR', flagEmoji: '🇫🇷'),
  ];
}
