import 'dart:async';
import 'package:get/get.dart';
import '../models/exam.dart';
import '../models/exam_question.dart';
import '../models/question.dart';
import '../models/question_status.dart';
import '../services/static_data.dart';
import '../utils/exam_constants.dart';

class ExamInterfaceController extends GetxController {
  final RxList<ExamQuestion> _examQuestions = <ExamQuestion>[].obs;
  final RxInt _currentQuestionIndex = 0.obs;
  final RxInt _remainingTimeInSeconds = 0.obs;
  final RxBool _isExamStarted = false.obs;
  final RxBool _isExamCompleted = false.obs;
  final RxBool _isPaletteVisible = false.obs;
  final RxBool _isLoading = false.obs;
  
  Timer? _examTimer;
  Exam? _currentExam;
  
  List<ExamQuestion> get examQuestions => _examQuestions;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  int get remainingTimeInSeconds => _remainingTimeInSeconds.value;
  bool get isExamStarted => _isExamStarted.value;
  bool get isExamCompleted => _isExamCompleted.value;
  bool get isPaletteVisible => _isPaletteVisible.value;
  bool get isLoading => _isLoading.value;
  
  ExamQuestion? get currentQuestion {
    if (_examQuestions.isEmpty || _currentQuestionIndex.value >= _examQuestions.length) {
      return null;
    }
    return _examQuestions[_currentQuestionIndex.value];
  }
  
  String get formattedTime {
    final hours = _remainingTimeInSeconds.value ~/ 3600;
    final minutes = (_remainingTimeInSeconds.value % 3600) ~/ 60;
    final seconds = _remainingTimeInSeconds.value % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  Map<QuestionStatus, int> get questionStatusCounts {
    final counts = <QuestionStatus, int>{};
    for (final status in QuestionStatus.values) {
      counts[status] = 0;
    }
    
    for (final examQuestion in _examQuestions) {
      counts[examQuestion.status] = (counts[examQuestion.status] ?? 0) + 1;
    }
    
    return counts;
  }
  
  bool get canGoNext => _currentQuestionIndex.value < _examQuestions.length - 1;
  bool get canGoPrevious => _currentQuestionIndex.value > 0;
  
  @override
  void onClose() {
    _examTimer?.cancel();
    super.onClose();
  }
  
  Future<void> initializeExam(Exam exam) async {
    _isLoading.value = true;
    _currentExam = exam;
    
    try {
      // Simulate loading questions from API
      await Future.delayed(Duration(milliseconds: 500));
      
      // Get questions for the exam (using static data for now)
      final questions = StaticData.questions.take(exam.totalQuestions).toList();
      
      _examQuestions.value = questions.map((question) => ExamQuestion(question: question)).toList();
      _remainingTimeInSeconds.value = exam.duration * 60; // Convert minutes to seconds
      _currentQuestionIndex.value = 0;
      _isExamStarted.value = false;
      _isExamCompleted.value = false;
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load exam questions');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void startExam() {
    _isExamStarted.value = true;
    _startTimer();
    
    // Mark first question as visited
    if (_examQuestions.isNotEmpty) {
      _markQuestionAsVisited(0);
    }
  }
  
  void _startTimer() {
    _examTimer?.cancel();
    _examTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTimeInSeconds.value > 0) {
        _remainingTimeInSeconds.value--;
        _checkTimeWarnings();
      } else {
        _autoSubmitExam();
      }
    });
  }
  
  void _checkTimeWarnings() {
    final remainingMinutes = _remainingTimeInSeconds.value ~/ 60;
    
    if (remainingMinutes == 15 && _remainingTimeInSeconds.value % 60 == 0) {
      Get.snackbar('Time Warning', ExamConstants.examWarnings['timeWarning']!);
    } else if (remainingMinutes == 5 && _remainingTimeInSeconds.value % 60 == 0) {
      Get.snackbar('Final Warning', ExamConstants.examWarnings['finalWarning']!);
    }
  }
  
  void _autoSubmitExam() {
    _examTimer?.cancel();
    Get.snackbar('Time Up', ExamConstants.examWarnings['autoSubmit']!);
    submitExam();
  }
  
  void goToQuestion(int index) {
    if (index >= 0 && index < _examQuestions.length) {
      _currentQuestionIndex.value = index;
      _markQuestionAsVisited(index);
    }
  }
  
  void nextQuestion() {
    if (canGoNext) {
      _currentQuestionIndex.value++;
      _markQuestionAsVisited(_currentQuestionIndex.value);
    }
  }
  
  void previousQuestion() {
    if (canGoPrevious) {
      _currentQuestionIndex.value--;
      _markQuestionAsVisited(_currentQuestionIndex.value);
    }
  }
  
  void selectAnswer(String answer) {
    final currentIndex = _currentQuestionIndex.value;
    if (currentIndex < _examQuestions.length) {
      _examQuestions[currentIndex] = _examQuestions[currentIndex].copyWith(
        selectedAnswer: answer,
        answeredAt: DateTime.now(),
      );
      _examQuestions.refresh();
    }
  }
  
  void toggleMarkForReview() {
    final currentIndex = _currentQuestionIndex.value;
    if (currentIndex < _examQuestions.length) {
      _examQuestions[currentIndex] = _examQuestions[currentIndex].copyWith(
        isMarkedForReview: !_examQuestions[currentIndex].isMarkedForReview,
      );
      _examQuestions.refresh();
    }
  }
  
  void clearAnswer() {
    final currentIndex = _currentQuestionIndex.value;
    if (currentIndex < _examQuestions.length) {
      _examQuestions[currentIndex] = _examQuestions[currentIndex].copyWith(
        clearSelectedAnswer: true,
      );
      _examQuestions.refresh();
    }
  }
  
  void _markQuestionAsVisited(int index) {
    if (index < _examQuestions.length && !_examQuestions[index].isVisited) {
      _examQuestions[index] = _examQuestions[index].copyWith(isVisited: true);
      _examQuestions.refresh();
    }
  }
  
  void toggleQuestionPalette() {
    _isPaletteVisible.value = !_isPaletteVisible.value;
  }
  
  void hideQuestionPalette() {
    _isPaletteVisible.value = false;
  }
  
  Future<void> submitExam() async {
    try {
      _examTimer?.cancel();
      _isExamCompleted.value = true;
      
      // Calculate results
      final answeredQuestions = _examQuestions.where((q) => q.isAnswered).length;
      final correctAnswers = _examQuestions.where((q) => 
        q.isAnswered && q.selectedAnswer == q.question.correctAnswer
      ).length;
      
      // Show results dialog
      Get.dialog(
        AlertDialog(
          title: Text('Exam Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Questions: ${_examQuestions.length}'),
              Text('Answered: $answeredQuestions'),
              Text('Correct Answers: $correctAnswers'),
              Text('Score: ${(correctAnswers / _examQuestions.length * 100).toStringAsFixed(1)}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Go back to previous screen
              },
              child: Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit exam');
    }
  }
  
  void showSubmitConfirmation() {
    final unansweredCount = _examQuestions.where((q) => !q.isAnswered).length;
    
    Get.dialog(
      AlertDialog(
        title: Text('Submit Exam'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to submit the exam?'),
            if (unansweredCount > 0) ..[
              SizedBox(height: 8),
              Text(
                'You have $unansweredCount unanswered questions.',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              submitExam();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}