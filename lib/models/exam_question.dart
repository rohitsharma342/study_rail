import 'question.dart';
import 'question_status.dart';

class ExamQuestion {
  final Question question;
  final String? selectedAnswer;
  final bool isMarkedForReview;
  final bool isVisited;
  final DateTime? answeredAt;

  ExamQuestion({
    required this.question,
    this.selectedAnswer,
    this.isMarkedForReview = false,
    this.isVisited = false,
    this.answeredAt,
  });

  ExamQuestion copyWith({
    Question? question,
    String? selectedAnswer,
    bool? isMarkedForReview,
    bool? isVisited,
    DateTime? answeredAt,
    bool clearSelectedAnswer = false,
  }) {
    return ExamQuestion(
      question: question ?? this.question,
      selectedAnswer: clearSelectedAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      isMarkedForReview: isMarkedForReview ?? this.isMarkedForReview,
      isVisited: isVisited ?? this.isVisited,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  bool get isAnswered => selectedAnswer != null;

  QuestionStatus get status {
    if (!isVisited) return QuestionStatus.notVisited;
    if (isAnswered && isMarkedForReview) return QuestionStatus.answeredAndMarked;
    if (isMarkedForReview) return QuestionStatus.markedForReview;
    if (isAnswered) return QuestionStatus.answered;
    return QuestionStatus.notAnswered;
  }
}