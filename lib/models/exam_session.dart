import 'question.dart';
import 'question_status.dart';

class ExamSession {
  final String id;
  final String testId;
  final String testTitle;
  final List<Question> questions;
  final int totalDuration; // in seconds
  final DateTime startTime;
  int currentQuestionIndex;
  int remainingTime; // in seconds
  bool isActive;
  bool isSubmitted;
  Map<String, QuestionStatus> questionStatuses;
  Map<String, String?> userAnswers;
  Set<String> markedForReview;
  DateTime? endTime;

  ExamSession({
    required this.id,
    required this.testId,
    required this.testTitle,
    required this.questions,
    required this.totalDuration,
    required this.startTime,
    this.currentQuestionIndex = 0,
    int? remainingTime,
    this.isActive = true,
    this.isSubmitted = false,
    Map<String, QuestionStatus>? questionStatuses,
    Map<String, String?>? userAnswers,
    Set<String>? markedForReview,
    this.endTime,
  }) : remainingTime = remainingTime ?? totalDuration,
       questionStatuses = questionStatuses ?? {},
       userAnswers = userAnswers ?? {},
       markedForReview = markedForReview ?? {} {
    _initializeQuestionStatuses();
  }

  void _initializeQuestionStatuses() {
    for (int i = 0; i < questions.length; i++) {
      final questionId = questions[i].id;
      if (!questionStatuses.containsKey(questionId)) {
        questionStatuses[questionId] = QuestionStatus.notVisited;
      }
    }
  }

  Question get currentQuestion => questions[currentQuestionIndex];
  
  int get totalQuestions => questions.length;
  
  int get answeredCount => questionStatuses.values
      .where((status) => status == QuestionStatus.answered || 
                        status == QuestionStatus.answeredAndMarked)
      .length;
  
  int get notAnsweredCount => questionStatuses.values
      .where((status) => status == QuestionStatus.notAnswered)
      .length;
  
  int get markedCount => questionStatuses.values
      .where((status) => status == QuestionStatus.markedForReview || 
                        status == QuestionStatus.answeredAndMarked)
      .length;
  
  int get notVisitedCount => questionStatuses.values
      .where((status) => status == QuestionStatus.notVisited)
      .length;

  void visitQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      final questionId = questions[index].id;
      if (questionStatuses[questionId] == QuestionStatus.notVisited) {
        questionStatuses[questionId] = QuestionStatus.notAnswered;
      }
      currentQuestionIndex = index;
    }
  }

  void answerQuestion(String questionId, String answer) {
    userAnswers[questionId] = answer;
    
    if (markedForReview.contains(questionId)) {
      questionStatuses[questionId] = QuestionStatus.answeredAndMarked;
    } else {
      questionStatuses[questionId] = QuestionStatus.answered;
    }
  }

  void markForReview(String questionId) {
    markedForReview.add(questionId);
    
    if (userAnswers.containsKey(questionId) && userAnswers[questionId] != null) {
      questionStatuses[questionId] = QuestionStatus.answeredAndMarked;
    } else {
      questionStatuses[questionId] = QuestionStatus.markedForReview;
    }
  }

  void unmarkForReview(String questionId) {
    markedForReview.remove(questionId);
    
    if (userAnswers.containsKey(questionId) && userAnswers[questionId] != null) {
      questionStatuses[questionId] = QuestionStatus.answered;
    } else {
      questionStatuses[questionId] = QuestionStatus.notAnswered;
    }
  }

  void clearAnswer(String questionId) {
    userAnswers.remove(questionId);
    
    if (markedForReview.contains(questionId)) {
      questionStatuses[questionId] = QuestionStatus.markedForReview;
    } else {
      questionStatuses[questionId] = QuestionStatus.notAnswered;
    }
  }

  void submitExam() {
    isActive = false;
    isSubmitted = true;
    endTime = DateTime.now();
  }

  String getFormattedTime() {
    int hours = remainingTime ~/ 3600;
    int minutes = (remainingTime % 3600) ~/ 60;
    int seconds = remainingTime % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progressPercentage {
    return (totalDuration - remainingTime) / totalDuration;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testId': testId,
      'testTitle': testTitle,
      'questions': questions.map((q) => q.toJson()).toList(),
      'totalDuration': totalDuration,
      'startTime': startTime.toIso8601String(),
      'currentQuestionIndex': currentQuestionIndex,
      'remainingTime': remainingTime,
      'isActive': isActive,
      'isSubmitted': isSubmitted,
      'questionStatuses': questionStatuses.map((k, v) => MapEntry(k, v.index)),
      'userAnswers': userAnswers,
      'markedForReview': markedForReview.toList(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}