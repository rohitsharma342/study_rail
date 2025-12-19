class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? department;
  final List<String> purchasedModules;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.department,
    this.purchasedModules = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      department: json['department']?.toString(),
      purchasedModules: json['purchasedModules'] != null
          ? List<String>.from(json['purchasedModules'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'purchasedModules': purchasedModules,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? department,
    List<String>? purchasedModules,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      purchasedModules: purchasedModules ?? this.purchasedModules,
    );
  }
}