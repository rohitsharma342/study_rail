import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/data_service.dart';
import 'auth_controller.dart';

class QuestionController extends GetxController {
  final DataService _dataService = DataService();
  final AuthController authController = Get.find<AuthController>();
  
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final RxList<String> subjects = <String>[].obs;
  final RxList<String> selectedSubjects = <String>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
    loadQuestions();
  }

  void loadSubjects() {
    subjects.value = _dataService.getSubjects();
  }

  void loadQuestions() {
    final questionData = _dataService.getQuestionBankData();
    questions.value = questionData.map((data) => QuestionModel.fromJson(data)).toList();
  }

  List<QuestionModel> get filteredQuestions {
    var filtered = questions.where((question) {
      // Filter by selected subjects
      if (selectedSubjects.isNotEmpty && 
          !selectedSubjects.contains(question.subject)) {
        return false;
      }
      
      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        return question.question.toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }
      
      return true;
    }).toList();
    
    return filtered;
  }

  void toggleSubjectFilter(String subject) {
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      // Check if user has access to this subject
      if (authController.user == null || !authController.user!.hasAccessToSubject(subject)) {
        Get.snackbar(
          'Access Denied',
          'Please purchase access to $subject to practice questions.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      selectedSubjects.add(subject);
    }
    currentQuestionIndex.value = 0; // Reset to first question
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentQuestionIndex.value = 0; // Reset to first question
  }

  void nextQuestion() {
    final filtered = filteredQuestions;
    if (filtered.isNotEmpty && currentQuestionIndex.value < filtered.length - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void selectAnswer(int optionIndex) {
    final filtered = filteredQuestions;
    if (filtered.isNotEmpty) {
      final currentQuestion = filtered[currentQuestionIndex.value];
      currentQuestion.selectedAnswer = optionIndex.toString();
      
      // Update the original question in the main list
      final originalIndex = questions.indexWhere((q) => q.id == currentQuestion.id);
      if (originalIndex != -1) {
        questions[originalIndex] = currentQuestion;
      }
    }
  }

  QuestionModel? get currentQuestion {
    final filtered = filteredQuestions;
    if (filtered.isNotEmpty && currentQuestionIndex.value < filtered.length) {
      return filtered[currentQuestionIndex.value];
    }
    return null;
  }

  bool hasAccessToSubject(String subject) {
    return authController.user?.hasAccessToSubject(subject) ?? false;
  }

  void purchaseSubjectAccess(String subject) {
    // Show purchase dialog or navigate to purchase screen
    Get.dialog(
      AlertDialog(
        title: Text('Purchase Access'),
        content: Text('Do you want to purchase access to $subject questions?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              authController.purchaseSubject(subject);
              Get.back();
              Get.snackbar(
                'Success',
                'Access to $subject purchased successfully!',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Text('Purchase'),
          ),
        ],
      ),
    );
  }
}