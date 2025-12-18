class AppConstants {
  static const String appName = 'Study Rail';
  static const String tagline = 'Made With BrainBox';
  static const String copyright = '© 2024 BrainBox Solutions. All rights reserved.';
  
  static const Duration splashDuration = Duration(seconds: 3);
  static const int questionsPerPage = 20;
  static const int testDurationMinutes = 120;
  
  static const List<String> subjects = [
    'General Knowledge',
    'Railway Administration',
    'Technical Knowledge',
    'Safety Rules',
    'Operating Procedures',
    'Accounts & Finance',
    'Personnel Management',
    'Commercial Rules'
  ];
  
  static const Map<String, String> testTypes = {
    'fullLength': 'Full Length Tests',
    'short': 'Short Tests',
    'subject': 'Subject-wise Tests',
    'misc': 'Miscellaneous Tests'
  };
}