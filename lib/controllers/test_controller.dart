import 'package:get/get.dart';
import '../models/test.dart';
import '../services/static_data.dart';
import 'dart:async';

class TestController extends GetxController {
  final RxList<TestSeries> _testSeries = <TestSeries>[].obs;
  final RxList<String> _selectedTests = <String>[].obs;
  final RxBool _isLoading = false.obs;
  final RxInt _currentQuestionIndex = 0.obs;
  final RxInt _remainingTime = 0.obs;
  Timer? _testTimer;
  final RxBool _isTestActive = false.obs;

  List<TestSeries> get testSeries => _testSeries;
  List<String> get selectedTests => _selectedTests;
  bool get isLoading => _isLoading.value;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  int get remainingTime => _remainingTime.value;
  bool get isTestActive => _isTestActive.value;

  double get totalPrice {
    return _testSeries
        .where((test) => _selectedTests.contains(test.id))
        .fold(0.0, (sum, test) => sum + test.price);
  }

  double get totalDiscountedPrice {
    return _testSeries
        .where((test) => _selectedTests.contains(test.id))
        .fold(0.0, (sum, test) => sum + test.discountedPrice);
  }

  double get totalSavings => totalPrice - totalDiscountedPrice;

  @override
  void onInit() {
    super.onInit();
    loadTestSeries();
  }

  @override
  void onClose() {
    _testTimer?.cancel();
    super.onClose();
  }

  Future<void> loadTestSeries() async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 1));
      _testSeries.value = StaticData.testSeries;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load test series');
    } finally {
      _isLoading.value = false;
    }
  }

  void toggleTestSelection(String testId) {
    if (_selectedTests.contains(testId)) {
      _selectedTests.remove(testId);
    } else {
      _selectedTests.add(testId);
    }
  }

  Future<bool> purchaseSelectedTests() async {
    if (_selectedTests.isEmpty) {
      Get.snackbar('Error', 'Please select at least one test series');
      return false;
    }

    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 2));
      
      for (String testId in _selectedTests) {
        final index = _testSeries.indexWhere((test) => test.id == testId);
        if (index != -1) {
          _testSeries[index] = TestSeries(
            id: _testSeries[index].id,
            title: _testSeries[index].title,
            description: _testSeries[index].description,
            type: _testSeries[index].type,
            questionsCount: _testSeries[index].questionsCount,
            duration: _testSeries[index].duration,
            price: _testSeries[index].price,
            discountedPrice: _testSeries[index].discountedPrice,
            isPurchased: true,
            scheduledDate: _testSeries[index].scheduledDate,
            subjects: _testSeries[index].subjects,
            imageUrl: _testSeries[index].imageUrl,
          );
        }
      }
      
      _selectedTests.clear();
      Get.snackbar('Success', 'Purchase completed successfully!');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Purchase failed. Please try again.');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void startTest(String testId) {
    final test = _testSeries.firstWhere((t) => t.id == testId);
    
    if (!test.isPurchased) {
      Get.snackbar('Error', 'Please purchase this test series first');
      return;
    }

    _currentQuestionIndex.value = 0;
    _remainingTime.value = test.duration * 60;
    _isTestActive.value = true;
    
    startTimer();
    Get.snackbar('Test Started', 'Good luck with your test!');
  }

  void startTimer() {
    _testTimer?.cancel();
    _testTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
      } else {
        endTest();
      }
    });
  }

  void endTest() {
    _testTimer?.cancel();
    _isTestActive.value = false;
    Get.snackbar('Test Completed', 'Your test has been submitted');
  }

  void nextQuestion() {
    if (_currentQuestionIndex.value < 119) {
      _currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex.value > 0) {
      _currentQuestionIndex.value--;
    }
  }

  void jumpToQuestion(int index) {
    _currentQuestionIndex.value = index;
  }

  String getFormattedTime() {
    int hours = _remainingTime.value ~/ 3600;
    int minutes = (_remainingTime.value % 3600) ~/ 60;
    int seconds = _remainingTime.value % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}