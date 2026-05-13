class ExpertiseEntity {
  final String id;
  final String name;

  const ExpertiseEntity({
    required this.id,
    required this.name,
  });

  /// Mock data for expertise categories
  static const List<ExpertiseEntity> mocks = [
    ExpertiseEntity(id: '1', name: 'Design'),
    ExpertiseEntity(id: '2', name: 'Sales'),
    ExpertiseEntity(id: '3', name: 'Marketing'),
    ExpertiseEntity(id: '4', name: 'Finance'),
    ExpertiseEntity(id: '5', name: 'Education'),
    ExpertiseEntity(id: '6', name: 'Programming'),
    ExpertiseEntity(id: '7', name: 'Data Science'),
    ExpertiseEntity(id: '8', name: 'Management'),
    ExpertiseEntity(id: '9', name: 'Healthcare'),
    ExpertiseEntity(id: '10', name: 'Engineering'),
    ExpertiseEntity(id: '11', name: 'Customer Support'),
  ];
}
