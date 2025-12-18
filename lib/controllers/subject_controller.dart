import 'package:get/get.dart';
import '../models/subject.dart';
import '../models/question.dart';
import '../services/static_data.dart';
import 'exam_controller.dart';
import 'question_controller.dart';

class SubjectController extends GetxController {
  final RxList<Subject> _subjects = <Subject>[].obs;
  final Rx<Subject?> _selectedSubject = Rx<Subject?>(null);
  final RxBool _isLoading = false.obs;
  
  final ExamController examController = Get.find<ExamController>();
  final QuestionController questionController = Get.find<QuestionController>();

  List<Subject> get subjects => _subjects;
  Subject? get selectedSubject => _selectedSubject.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
    
    // Listen to exam changes
    ever(examController.selectedExamObs, (_) {
      loadSubjects();
    });
  }

  Future<void> loadSubjects() async {
    if (examController.selectedExam == null) return;
    
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(milliseconds: 300)); // Simulate API call
      _subjects.value = StaticData.getSubjectsForExam(examController.selectedExam!.id);
      _updateSubjectProgress();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load subjects');
    } finally {
      _isLoading.value = false;
    }
  }

  void selectSubject(Subject subject) {
    _selectedSubject.value = subject;
    // Filter questions by selected subject
    questionController.filterQuestionsBySubject(subject.name);
  }

  void _updateSubjectProgress() {
    for (int i = 0; i < _subjects.length; i++) {
      final subject = _subjects[i];
      final subjectQuestions = questionController.questions
          .where((q) => q.subject == subject.name)
          .toList();
      
      final answeredCount = subjectQuestions.where((q) => q.isAnswered).length;
      final progressPercentage = subjectQuestions.isNotEmpty 
          ? (answeredCount / subjectQuestions.length) * 100 
          : 0.0;
      
      _subjects[i] = Subject(
        id: subject.id,
        name: subject.name,
        examId: subject.examId,
        description: subject.description,
        totalQuestions: subjectQuestions.length,
        iconUrl: subject.iconUrl,
        color: subject.color,
        completedQuestions: answeredCount,
        progressPercentage: progressPercentage,
      );
    }
    _subjects.refresh();
  }

  void refreshProgress() {
    _updateSubjectProgress();
  }
}