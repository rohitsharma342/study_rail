import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/test_model.dart';
import '../models/question_model.dart';
import '../services/data_service.dart';
import 'auth_controller.dart';

class TestController extends GetxController {
  final DataService _dataService = DataService();
  final AuthController authController = Get.find<AuthController>();
  
  final RxList<TestModel> tests = <TestModel>[].obs;
  final RxList<TestModel> selectedTests = <TestModel>[].obs;
  final RxList<QuestionModel> testQuestions = <QuestionModel>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxInt timeRemaining = 0.obs;
  final RxBool isTestActive = false.obs;
  final RxString selectedFilter = 'All'.obs;
  
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadTests();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void loadTests() {
    final testData = _dataService.getTestData();
    tests.value = testData.map((data) => TestModel.fromJson(data)).toList();
  }

  List<TestModel> get filteredTests {
    if (selectedFilter.value == 'All') {
      return tests;
    }
    return tests.where((test) => test.category == selectedFilter.value).toList();
  }

  void toggleTestSelection(TestModel test) {
    if (selectedTests.contains(test)) {
      selectedTests.remove(test);
    } else {
      selectedTests.add(test);
    }
  }

  double get totalOriginalPrice {
    return selectedTests.fold(0.0, (sum, test) => sum + test.price);
  }

  double get totalDiscountedPrice {
    return selectedTests.fold(0.0, (sum, test) => sum + test.discountedPrice);
  }

  double get totalSavings => totalOriginalPrice - totalDiscountedPrice;

  Future<bool> purchaseSelectedTests() async {
    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));
      
      for (var test in selectedTests) {
        authController.purchaseTest(test.id);
      }
      
      selectedTests.clear();
      loadTests(); // Refresh to update purchase status
      
      Get.snackbar(
        'Success',
        'Tests purchased successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Purchase failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  void startTest(TestModel test) {
    if (!authController.user!.hasAccessToTest(test.id)) {
      Get.snackbar(
        'Access Denied',
        'Please purchase this test to access it.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final questions = _dataService.getTestQuestions(test.id);
    testQuestions.value = questions.map((q) => QuestionModel.fromJson(q)).toList();
    currentQuestionIndex.value = 0;
    timeRemaining.value = test.duration * 60; // Convert to seconds
    isTestActive.value = true;
    
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        submitTest();
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < testQuestions.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void selectAnswer(int optionIndex) {
    final currentQuestion = testQuestions[currentQuestionIndex.value];
    currentQuestion.selectedAnswer = optionIndex.toString();
    testQuestions[currentQuestionIndex.value] = currentQuestion;
  }

  void markForReview() {
    final currentQuestion = testQuestions[currentQuestionIndex.value];
    currentQuestion.isMarkedForReview = !currentQuestion.isMarkedForReview;
    testQuestions[currentQuestionIndex.value] = currentQuestion;
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < testQuestions.length) {
      currentQuestionIndex.value = index;
    }
  }

  void submitTest() {
    _timer?.cancel();
    isTestActive.value = false;
    
    int correctAnswers = 0;
    int totalAnswered = 0;
    
    for (var question in testQuestions) {
      if (question.isAnswered) {
        totalAnswered++;
        if (question.isCorrect) {
          correctAnswers++;
        }
      }
    }
    
    final score = (correctAnswers / testQuestions.length) * 100;
    
    Get.dialog(
      AlertDialog(
        title: Text('Test Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: ${score.toStringAsFixed(1)}%'),
            Text('Correct: $correctAnswers/${testQuestions.length}'),
            Text('Attempted: $totalAnswered/${testQuestions.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back(); // Go back to tests list
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String get formattedTimeRemaining {
    final minutes = timeRemaining.value ~/ 60;
    final seconds = timeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}