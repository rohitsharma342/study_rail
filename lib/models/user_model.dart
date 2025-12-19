class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? department;
  final List<String> purchasedModules;
  final List<String> purchasedTests;
  final List<String> purchasedSubjects;
  final Map<String, dynamic> testScores;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.department,
    this.purchasedModules = const [],
    this.purchasedTests = const [],
    this.purchasedSubjects = const [],
    this.testScores = const {},
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      department: json['department']?.toString(),
      purchasedModules: json['purchasedModules'] != null
          ? List<String>.from(json['purchasedModules'])
          : [],
      purchasedTests: json['purchasedTests'] != null
          ? List<String>.from(json['purchasedTests'])
          : [],
      purchasedSubjects: json['purchasedSubjects'] != null
          ? List<String>.from(json['purchasedSubjects'])
          : [],
      testScores: json['testScores'] != null
          ? Map<String, dynamic>.from(json['testScores'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'purchasedModules': purchasedModules,
      'purchasedTests': purchasedTests,
      'purchasedSubjects': purchasedSubjects,
      'testScores': testScores,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    List<String>? purchasedModules,
    List<String>? purchasedTests,
    List<String>? purchasedSubjects,
    Map<String, dynamic>? testScores,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      purchasedModules: purchasedModules ?? this.purchasedModules,
      purchasedTests: purchasedTests ?? this.purchasedTests,
      purchasedSubjects: purchasedSubjects ?? this.purchasedSubjects,
      testScores: testScores ?? this.testScores,
    );
  }

  bool hasAccessToTest(String testId) {
    return purchasedTests.contains(testId);
  }

  bool hasAccessToSubject(String subject) {
    return purchasedSubjects.contains(subject);
  }
}