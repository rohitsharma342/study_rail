class Exam {
  final String id;
  final String name;
  final String code;
  final String description;
  final List<String> subjects;
  final int totalQuestions;
  final int duration;
  final String level;
  final String? iconUrl;
  final int? color;

  Exam({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.subjects,
    required this.totalQuestions,
    required this.duration,
    required this.level,
    this.iconUrl,
    this.color,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      subjects: List<String>.from(json['subjects']),
      totalQuestions: json['totalQuestions'],
      duration: json['duration'],
      level: json['level'],
      iconUrl: json['iconUrl'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'subjects': subjects,
      'totalQuestions': totalQuestions,
      'duration': duration,
      'level': level,
      'iconUrl': iconUrl,
      'color': color,
    };
  }
}