import 'package:get/get.dart';
import '../models/question.dart';
import '../services/static_data.dart';
import '../utils/constants.dart';

class QuestionController extends GetxController {
  final RxList<Question> _questions = <Question>[].obs;
  final RxList<Question> _filteredQuestions = <Question>[].obs;
  final RxList<String> _selectedSubjects = <String>[].obs;
  final RxBool _isLoading = false.obs;
  final RxInt _currentQuestionIndex = 0.obs;
  final RxString _searchQuery = ''.obs;

  List<Question> get questions => _questions;
  List<Question> get filteredQuestions => _filteredQuestions;
  List<String> get selectedSubjects => _selectedSubjects;
  bool get isLoading => _isLoading.value;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  String get searchQuery => _searchQuery.value;

  Question? get currentQuestion {
    if (_filteredQuestions.isNotEmpty && 
        _currentQuestionIndex.value < _filteredQuestions.length) {
      return _filteredQuestions[_currentQuestionIndex.value];
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      _questions.value = StaticData.questions;
      _filteredQuestions.value = _questions;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load questions');
    } finally {
      _isLoading.value = false;
    }
  }

  void filterQuestions() {
    List<Question> filtered = _questions;

    // Filter by selected subjects
    if (_selectedSubjects.isNotEmpty) {
      filtered = filtered
          .where((q) => _selectedSubjects.contains(q.subject))
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((q) => 
              q.question.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
              q.subject.toLowerCase().contains(_searchQuery.value.toLowerCase()))
          .toList();
    }

    _filteredQuestions.value = filtered;
    _currentQuestionIndex.value = 0;
  }

  void toggleSubjectFilter(String subject) {
    if (_selectedSubjects.contains(subject)) {
      _selectedSubjects.remove(subject);
    } else {
      _selectedSubjects.add(subject);
    }
    filterQuestions();
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
    filterQuestions();
  }

  void clearFilters() {
    _selectedSubjects.clear();
    _searchQuery.value = '';
    _filteredQuestions.value = _questions;
    _currentQuestionIndex.value = 0;
  }

  void nextQuestion() {
    if (_currentQuestionIndex.value < _filteredQuestions.length - 1) {
      _currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex.value > 0) {
      _currentQuestionIndex.value--;
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < _filteredQuestions.length) {
      _currentQuestionIndex.value = index;
    }
  }

  void selectAnswer(String answer) {
    if (currentQuestion != null) {
      final index = _questions.indexWhere((q) => q.id == currentQuestion!.id);
      if (index != -1) {
        _questions[index].userAnswer = answer;
        _questions.refresh();
        _filteredQuestions.refresh();
      }
    }
  }

  void toggleMarkForReview() {
    if (currentQuestion != null) {
      final index = _questions.indexWhere((q) => q.id == currentQuestion!.id);
      if (index != -1) {
        _questions[index].isMarkedForReview = !_questions[index].isMarkedForReview;
        _questions.refresh();
        _filteredQuestions.refresh();
      }
    }
  }

  int get answeredCount {
    return _filteredQuestions.where((q) => q.isAnswered).length;
  }

  int get markedForReviewCount {
    return _filteredQuestions.where((q) => q.isMarkedForReview).length;
  }

  double get progressPercentage {
    if (_filteredQuestions.isEmpty) return 0.0;
    return (answeredCount / _filteredQuestions.length) * 100;
  }

  List<String> get availableSubjects {
    return AppConstants.subjects;
  }
}