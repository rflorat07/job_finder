/// Represents a job recommendation that matches the user's profile.
class JobMatchEntity {
  final String id;
  final String jobTitle;
  final String companyName;
  final String companyLogoUrl;
  final String location;
  final String salary;
  final List<String> tags;
  final DateTime postedAt;

  const JobMatchEntity({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoUrl,
    required this.location,
    required this.salary,
    required this.tags,
    required this.postedAt,
  });

  /// Mock data for UI development.
  static final List<JobMatchEntity> mocks = [
    JobMatchEntity(
      id: '1',
      jobTitle: 'Senior Product Designer',
      companyName: 'Stripe',
      companyLogoUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQGluJhW7I1NYU7jF77E-9K9I46_ib_DUNHw&s',
      location: 'San Francisco, CA',
      salary: r'$120k - $140k',
      tags: ['Remote', 'Full-time'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    JobMatchEntity(
      id: '2',
      jobTitle: 'Flutter Developer',
      companyName: 'Shopify',
      companyLogoUrl: 'assets/icons/shopify.svg',
      location: 'Toronto, Canada',
      salary: r'$90k - $110k',
      tags: ['Hybrid', 'Full-time'],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JobMatchEntity(
      id: '3',
      jobTitle: 'UX Researcher',
      companyName: 'Meta',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/6033/6033716.png',
      location: 'Menlo Park, CA',
      salary: r'$130k - $160k',
      tags: ['On-site', 'Full-time'],
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    JobMatchEntity(
      id: '4',
      jobTitle: 'Mobile Engineer',
      companyName: 'Pinterest',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/512/145/145808.png',
      location: 'Remote',
      salary: r'$100k - $125k',
      tags: ['Remote', 'Contract'],
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    JobMatchEntity(
      id: '5',
      jobTitle: 'Visual Designer',
      companyName: 'Figma',
      companyLogoUrl: 'https://cdn-icons-png.flaticon.com/128/5968/5968705.png',
      location: 'Remote',
      salary: r'$45/hr',
      tags: ['Remote', 'Part-time'],
      postedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
