class ExpertiseEntity {
  final String id;
  final String name;

  const ExpertiseEntity({
    required this.id,
    required this.name,
  });

  /// Mock data for expertise categories
  static const List<ExpertiseEntity> mocks = [
    ExpertiseEntity(id: '1', name: 'Accounting'),
    ExpertiseEntity(id: '2', name: 'Designer'),
    ExpertiseEntity(id: '3', name: 'Legal'),
    ExpertiseEntity(id: '4', name: 'Finance'),
    ExpertiseEntity(id: '5', name: 'Sales'),
    ExpertiseEntity(id: '6', name: 'Engineering'),
    ExpertiseEntity(id: '7', name: 'Architecture'),
    ExpertiseEntity(id: '8', name: 'Consultancy'),
    ExpertiseEntity(id: '9', name: 'Management'),
    ExpertiseEntity(id: '10', name: 'Customer Service'),
    ExpertiseEntity(id: '11', name: 'Public Service'),
    ExpertiseEntity(id: '12', name: 'IT'),
    ExpertiseEntity(id: '13', name: 'Writing'),
    ExpertiseEntity(id: '14', name: 'Security'),
    ExpertiseEntity(id: '15', name: 'Marketing'),
    ExpertiseEntity(id: '16', name: 'Programmer'),
  ];
}
