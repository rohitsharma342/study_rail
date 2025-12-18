import 'package:get/get.dart';
import 'dart:async';
import '../models/exam_session.dart';
import '../models/question.dart';
import '../models/question_status.dart';
import '../models/test.dart';
import '../services/static_data.dart';
import '../utils/app_routes.dart';

class CbtExamController extends GetxController {
  final Rx<ExamSession?> _examSession = Rx<ExamSession?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _showQuestionPalette = false.obs;
  final RxString _selectedAnswer = ''.obs;
  Timer? _examTimer;
  final RxBool _showSubmitDialog = false.obs;

  ExamSession? get examSession => _examSession.value;
  bool get isLoading => _isLoading.value;
  bool get showQuestionPalette => _showQuestionPalette.value;
  String get selectedAnswer => _selectedAnswer.value;
  bool get showSubmitDialog => _showSubmitDialog.value;

  Question? get currentQuestion => _examSession.value?.currentQuestion;
  int get currentQuestionIndex => _examSession.value?.currentQuestionIndex ?? 0;
  int get totalQuestions => _examSession.value?.totalQuestions ?? 0;
  String get formattedTime => _examSession.value?.getFormattedTime() ?? '00:00:00';

  @override
  void onClose() {
    _examTimer?.cancel();
    super.onClose();
  }

  Future<void> startExam(String testId) async {
    _isLoading.value = true;
    
    try {
      // Find the test
      final test = StaticData.testSeries.firstWhere((t) => t.id == testId);
      
      // Load questions for the test
      final questions = await _loadQuestionsForTest(testId);
      
      // Create exam session
      final session = ExamSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        testId: testId,
        testTitle: test.title,
        questions: questions,
        totalDuration: test.duration * 60, // Convert minutes to seconds
        startTime: DateTime.now(),
      );
      
      _examSession.value = session;
      
      // Visit first question
      session.visitQuestion(0);
      
      // Load current answer if exists
      _loadCurrentAnswer();
      
      // Start timer
      _startTimer();
      
      Get.snackbar('Exam Started', 'Good luck with your exam!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to start exam: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<Question>> _loadQuestionsForTest(String testId) async {
    // Simulate loading questions from API
    await Future.delayed(Duration(seconds: 1));
    
    // Return sample questions (in real app, this would come from API)
    return StaticData.getQuestionsForTest(testId);
  }

  void _startTimer() {
    _examTimer?.cancel();
    _examTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final session = _examSession.value;
      if (session != null && session.isActive) {
        if (session.remainingTime > 0) {
          session.remainingTime--;
          _examSession.refresh();
        } else {
          _autoSubmitExam();
        }
      }
    });
  }

  void _autoSubmitExam() {
    Get.snackbar('Time Up!', 'Your exam has been automatically submitted.');
    submitExam();
  }

  void selectAnswer(String answer) {
    _selectedAnswer.value = answer;
    
    final session = _examSession.value;
    final question = currentQuestion;
    
    if (session != null && question != null) {
      session.answerQuestion(question.id, answer);
      _examSession.refresh();
    }
  }

  void clearAnswer() {
    _selectedAnswer.value = '';
    
    final session = _examSession.value;
    final question = currentQuestion;
    
    if (session != null && question != null) {
      session.clearAnswer(question.id);
      _examSession.refresh();
    }
  }

  void markForReview() {
    final session = _examSession.value;
    final question = currentQuestion;
    
    if (session != null && question != null) {
      if (session.markedForReview.contains(question.id)) {
        session.unmarkForReview(question.id);
      } else {
        session.markForReview(question.id);
      }
      _examSession.refresh();
    }
  }

  void nextQuestion() {
    final session = _examSession.value;
    if (session != null && session.currentQuestionIndex < session.totalQuestions - 1) {
      _saveCurrentAnswer();
      session.visitQuestion(session.currentQuestionIndex + 1);
      _loadCurrentAnswer();
      _examSession.refresh();
    }
  }

  void previousQuestion() {
    final session = _examSession.value;
    if (session != null && session.currentQuestionIndex > 0) {
      _saveCurrentAnswer();
      session.visitQuestion(session.currentQuestionIndex - 1);
      _loadCurrentAnswer();
      _examSession.refresh();
    }
  }

  void jumpToQuestion(int index) {
    final session = _examSession.value;
    if (session != null && index >= 0 && index < session.totalQuestions) {
      _saveCurrentAnswer();
      session.visitQuestion(index);
      _loadCurrentAnswer();
      _examSession.refresh();
      _showQuestionPalette.value = false;
    }
  }

  void _saveCurrentAnswer() {
    final session = _examSession.value;
    final question = currentQuestion;
    
    if (session != null && question != null && _selectedAnswer.value.isNotEmpty) {
      session.answerQuestion(question.id, _selectedAnswer.value);
    }
  }

  void _loadCurrentAnswer() {
    final session = _examSession.value;
    final question = currentQuestion;
    
    if (session != null && question != null) {
      _selectedAnswer.value = session.userAnswers[question.id] ?? '';
    }
  }

  void toggleQuestionPalette() {
    _showQuestionPalette.value = !_showQuestionPalette.value;
  }

  void hideQuestionPalette() {
    _showQuestionPalette.value = false;
  }

  void showSubmitConfirmation() {
    _showSubmitDialog.value = true;
  }

  void hideSubmitConfirmation() {
    _showSubmitDialog.value = false;
  }

  void submitExam() {
    final session = _examSession.value;
    if (session != null) {
      _saveCurrentAnswer();
      session.submitExam();
      _examTimer?.cancel();
      _examSession.refresh();
      
      // Navigate to results screen
      Get.offNamed(AppRoutes.examResult, arguments: {
        'examSession': session,
      });
    }
  }

  QuestionStatus getQuestionStatus(int index) {
    final session = _examSession.value;
    if (session != null && index < session.questions.length) {
      final questionId = session.questions[index].id;
      return session.questionStatuses[questionId] ?? QuestionStatus.notVisited;
    }
    return QuestionStatus.notVisited;
  }

  bool isCurrentQuestionMarked() {
    final session = _examSession.value;
    final question = currentQuestion;
    
    if (session != null && question != null) {
      return session.markedForReview.contains(question.id);
    }
    return false;
  }

  bool canGoNext() {
    final session = _examSession.value;
    return session != null && session.currentQuestionIndex < session.totalQuestions - 1;
  }

  bool canGoPrevious() {
    final session = _examSession.value;
    return session != null && session.currentQuestionIndex > 0;
  }

  void pauseExam() {
    _examTimer?.cancel();
  }

  void resumeExam() {
    _startTimer();
  }
}