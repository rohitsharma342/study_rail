class User {
  final String id;
  final String name;
  final String email;
  final String department;
  final String designation;
  final List<String> purchasedModules;
  final DateTime lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.designation,
    required this.purchasedModules,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
      designation: json['designation'],
      purchasedModules: List<String>.from(json['purchasedModules']),
      lastLogin: DateTime.parse(json['lastLogin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'designation': designation,
      'purchasedModules': purchasedModules,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }
}