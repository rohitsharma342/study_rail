class User {
  final String id;
  final String name;
  final String email;
  final String department;
  final String designation;
  final String? employeeId;
  final List<String> purchasedModules;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.designation,
    this.employeeId,
    this.purchasedModules = const [],
    DateTime? lastLogin,
  }) : lastLogin = lastLogin ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
      designation: json['designation'],
      employeeId: json['employeeId'],
      purchasedModules: json['purchasedModules'] != null 
          ? List<String>.from(json['purchasedModules'])
          : [],
      lastLogin: json['lastLogin'] != null 
          ? DateTime.parse(json['lastLogin'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'designation': designation,
      'employeeId': employeeId,
      'purchasedModules': purchasedModules,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }
}