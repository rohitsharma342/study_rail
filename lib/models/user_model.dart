class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final List<String> purchasedTests;
  final List<String> purchasedSubjects;
  final Map<String, dynamic> testScores;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    this.purchasedTests = const [],
    this.purchasedSubjects = const [],
    this.testScores = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      department: json['department'],
      purchasedTests: List<String>.from(json['purchasedTests'] ?? []),
      purchasedSubjects: List<String>.from(json['purchasedSubjects'] ?? []),
      testScores: Map<String, dynamic>.from(json['testScores'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'purchasedTests': purchasedTests,
      'purchasedSubjects': purchasedSubjects,
      'testScores': testScores,
    };
  }

  bool hasAccessToTest(String testId) {
    return purchasedTests.contains(testId);
  }

  bool hasAccessToSubject(String subject) {
    return purchasedSubjects.contains(subject);
  }
}