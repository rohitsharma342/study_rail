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
  Rx<Exam?> get selectedExamObs => _selectedExam;

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
      
      // Auto-select first exam if none selected
      if (_selectedExam.value == null && _exams.isNotEmpty) {
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

  void clearSelection() {
    _selectedExam.value = null;
  }
}