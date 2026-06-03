/// Represents a recently posted job listing.
class RecentJobEntity {
  final String id;
  final String jobTitle;
  final String companyName;
  final String companyLogoUrl;
  final String location;
  final String salary;
  final String description;
  final List<String> tags;

  const RecentJobEntity({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoUrl,
    required this.location,
    required this.salary,
    required this.description,
    required this.tags,
  });

  /// Mock data for UI development.
  static const List<RecentJobEntity> mocks = [
    RecentJobEntity(
      id: '1',
      jobTitle: 'Project Manager',
      companyName: 'Meta',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/6033/6033716.png',
      location: 'California, United States',
      salary: r'$400 /Month',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard.',
      tags: ['Full Time', 'Design', 'Remote'],
    ),
    RecentJobEntity(
      id: '2',
      jobTitle: 'Graphic Designer',
      companyName: 'Webflow',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/5968/5968672.png',
      location: 'California, United States',
      salary: r'$370 /Month',
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard.',
      tags: ['Full Time', 'Design', 'Remote'],
    ),
    RecentJobEntity(
      id: '3',
      jobTitle: 'UI Designer',
      companyName: 'Pinterest',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/512/145/145808.png',
      location: 'New York, United States',
      salary: r'$450 /Month',
      description:
          'We are looking for a talented UI Designer to create amazing user experiences for our mobile and web platforms.',
      tags: ['Part Time', 'Design'],
    ),
    RecentJobEntity(
      id: '4',
      jobTitle: 'Frontend Developer',
      companyName: 'Stripe',
      companyLogoUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQGluJhW7I1NYU7jF77E-9K9I46_ib_DUNHw&s',
      location: 'San Francisco, United States',
      salary: r'$500 /Month',
      description:
          'Join our team to build the next generation of payment infrastructure used by millions of businesses worldwide.',
      tags: ['Full Time', 'Engineering', 'Remote'],
    ),
  ];
}
