class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String subject;
  final String explanation;
  final String difficulty;
  String? selectedAnswer;
  bool isMarkedForReview;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.subject,
    required this.explanation,
    required this.difficulty,
    this.selectedAnswer,
    this.isMarkedForReview = false,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      subject: json['subject'],
      explanation: json['explanation'],
      difficulty: json['difficulty'],
      selectedAnswer: json['selectedAnswer'],
      isMarkedForReview: json['isMarkedForReview'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'subject': subject,
      'explanation': explanation,
      'difficulty': difficulty,
      'selectedAnswer': selectedAnswer,
      'isMarkedForReview': isMarkedForReview,
    };
  }

  bool get isAnswered => selectedAnswer != null;
  bool get isCorrect => selectedAnswer != null && 
      int.tryParse(selectedAnswer!) == correctAnswer;
}