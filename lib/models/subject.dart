class Subject {
  final String id;
  final String name;
  final String examId;
  final String description;
  final int totalQuestions;
  final String? iconUrl;
  final String? color;
  final int completedQuestions;
  final double progressPercentage;

  Subject({
    required this.id,
    required this.name,
    required this.examId,
    required this.description,
    required this.totalQuestions,
    this.iconUrl,
    this.color,
    this.completedQuestions = 0,
    this.progressPercentage = 0.0,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      examId: json['examId'],
      description: json['description'],
      totalQuestions: json['totalQuestions'],
      iconUrl: json['iconUrl'],
      color: json['color'],
      completedQuestions: json['completedQuestions'] ?? 0,
      progressPercentage: json['progressPercentage'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'examId': examId,
      'description': description,
      'totalQuestions': totalQuestions,
      'iconUrl': iconUrl,
      'color': color,
      'completedQuestions': completedQuestions,
      'progressPercentage': progressPercentage,
    };
  }
}