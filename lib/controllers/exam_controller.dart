import 'package:get/get.dart';
import '../models/exam.dart';
import '../services/static_data.dart';

class ExamController extends GetxController {
  final RxList<Exam> _exams = <Exam>[].obs;
  final Rx<Exam?> _selectedExam = Rx<Exam?>(null);
  final RxBool _isLoading = false.obs;

  List<Exam> get exams => _exams;
  Exam? get selectedExam => _selectedExam.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadExams();
  }

  Future<void> loadExams() async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API call
      _exams.value = StaticData.exams;
      if (_exams.isNotEmpty) {
        _selectedExam.value = _exams.first;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load exams');
    } finally {
      _isLoading.value = false;
    }
  }

  void selectExam(Exam exam) {
    _selectedExam.value = exam;
  }

  void selectExamById(String examId) {
    final exam = _exams.firstWhereOrNull((e) => e.id == examId);
    if (exam != null) {
      _selectedExam.value = exam;
    }
  }

  List<String> get examNames {
    return _exams.map((exam) => exam.name).toList();
  }

  List<String> get examCodes {
    return _exams.map((exam) => exam.code).toList();
  }
}