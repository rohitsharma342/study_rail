class Question {
  final String id;
  final String question;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final int correctAnswerIndex;
  final String explanation;
  final String subject;
  final String difficulty;
  final List<String> tags;
  final String? imageUrl;
  String? userAnswer;
  bool isMarkedForReview;

  Question({
    required this.id,
    String? question,
    String? questionText,
    required this.options,
    String? correctAnswer,
    int? correctAnswerIndex,
    required this.explanation,
    required this.subject,
    required this.difficulty,
    this.tags = const [],
    this.imageUrl,
    this.userAnswer,
    this.isMarkedForReview = false,
  }) : question = question ?? questionText ?? '',
       questionText = questionText ?? question ?? '',
       correctAnswer = correctAnswer ?? (correctAnswerIndex != null && correctAnswerIndex < options.length ? options[correctAnswerIndex] : ''),
       correctAnswerIndex = correctAnswerIndex ?? (correctAnswer != null ? options.indexOf(correctAnswer) : 0);

  bool get isAnswered => userAnswer != null;
  bool get isCorrect => userAnswer != null && userAnswer == correctAnswer;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      subject: json['subject'],
      difficulty: json['difficulty'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'subject': subject,
      'difficulty': difficulty,
      'tags': tags,
      'imageUrl': imageUrl,
      'userAnswer': userAnswer,
      'isMarkedForReview': isMarkedForReview,
    };
  }
}