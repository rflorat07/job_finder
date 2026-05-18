class SetupPayloadEntity {
  final String countryCode;
  final List<String> expertiseIds;
  final List<String> officialAccountIds;
  final String fullName;
  final String username;
  final String bio;

  const SetupPayloadEntity({
    required this.countryCode,
    required this.expertiseIds,
    required this.officialAccountIds,
    required this.fullName,
    required this.username,
    required this.bio,
  });
}
