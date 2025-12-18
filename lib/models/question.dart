class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String subject;
  final String difficulty;
  final List<String> tags;
  String? userAnswer;
  bool isMarkedForReview;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.subject,
    required this.difficulty,
    required this.tags,
    this.userAnswer,
    this.isMarkedForReview = false,
  });

  bool get isAnswered => userAnswer != null;
  bool get isCorrect => userAnswer != null && userAnswer == correctAnswer.toString();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      subject: json['subject'],
      difficulty: json['difficulty'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'subject': subject,
      'difficulty': difficulty,
      'tags': tags,
      'userAnswer': userAnswer,
      'isMarkedForReview': isMarkedForReview,
    };
  }
}