class AppConstants {
  // Firestore collections
  static const String usersCollection = 'users';
  static const String studentsCollection = 'students';
  static const String clubsCollection = 'clubs';
  static const String eventsCollection = 'events';
  static const String joinRequestsCollection = 'join_requests';

  // User roles
  static const String studentRole = 'student';
  static const String clubManagerRole = 'club_manager';

  // Club categories
  static const List<String> clubCategories = [
    'Technology',
    'Sports',
    'Cultural',
    'Academic',
    'Social Service',
    'Photography',
    'Music',
    'Art',
    'Debate',
    'Others',
  ];

  // Student departments
  static const List<String> departments = [
    'CSE',
    'EEE',
    'ME',
    'CE',
    'MME',
    'IPE',
    'NAME',
    'PME',
    'BECM',
    'Arch',
    'URP',
    'Math',
    'Physics',
    'Chemistry',
    'Humanities',
  ];

  // Fields of interest
  static const List<String> fieldsOfInterest = [
    'Technology & Programming',
    'Sports & Fitness',
    'Arts & Culture',
    'Music & Dance',
    'Photography',
    'Social Service',
    'Debate & Public Speaking',
    'Academic Research',
    'Entrepreneurship',
    'Environment',
  ];

  // Club posts
  static const List<String> clubPosts = [
    'President',
    'Vice President',
    'General Secretary',
    'Joint General Secretary',
    'Organising Secretary',
    'Finance Secretary',
    'Program Coordinator',
    'Advertising Secretary',
    'Public Relations',
  ];
}