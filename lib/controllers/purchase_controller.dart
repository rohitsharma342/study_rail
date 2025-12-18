import 'package:get/get.dart';
import '../models/test.dart';
import '../models/study_material.dart';
import '../services/static_data.dart';

class PurchaseController extends GetxController {
  final RxList<TestSeries> _purchasedTests = <TestSeries>[].obs;
  final RxList<StudyMaterial> _purchasedMaterials = <StudyMaterial>[].obs;
  final RxBool _isLoading = false.obs;
  final RxDouble _totalSpent = 0.0.obs;

  List<TestSeries> get purchasedTests => _purchasedTests;
  List<StudyMaterial> get purchasedMaterials => _purchasedMaterials;
  bool get isLoading => _isLoading.value;
  double get totalSpent => _totalSpent.value;

  @override
  void onInit() {
    super.onInit();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      
      // Load purchased test series
      _purchasedTests.value = StaticData.testSeries
          .where((test) => test.isPurchased)
          .toList();
      
      // Load purchased study materials
      _purchasedMaterials.value = StaticData.studyMaterials
          .where((material) => material.isPurchased)
          .toList();
      
      // Calculate total spent
      double testTotal = _purchasedTests.fold(0.0, (sum, test) => sum + test.discountedPrice);
      _totalSpent.value = testTotal; // Add material costs if applicable
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load purchases');
    } finally {
      _isLoading.value = false;
    }
  }

  bool isTestPurchased(String testId) {
    return _purchasedTests.any((test) => test.id == testId);
  }

  bool isMaterialPurchased(String materialId) {
    return _purchasedMaterials.any((material) => material.id == materialId);
  }

  Future<bool> purchaseTest(String testId) async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate payment processing
      
      // Find the test and add to purchased list
      final test = StaticData.testSeries.firstWhere((t) => t.id == testId);
      _purchasedTests.add(test);
      _totalSpent.value += test.discountedPrice;
      
      Get.snackbar('Success', 'Test series purchased successfully!');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Purchase failed. Please try again.');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> purchaseMaterial(String materialId) async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate payment processing
      
      // Find the material and add to purchased list
      final material = StaticData.studyMaterials.firstWhere((m) => m.id == materialId);
      _purchasedMaterials.add(material);
      
      Get.snackbar('Success', 'Study material purchased successfully!');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Purchase failed. Please try again.');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Map<String, dynamic> getPurchaseSummary() {
    return {
      'totalTests': _purchasedTests.length,
      'totalMaterials': _purchasedMaterials.length,
      'totalSpent': _totalSpent.value,
      'averageTestPrice': _purchasedTests.isEmpty ? 0.0 : 
          _purchasedTests.fold(0.0, (sum, test) => sum + test.discountedPrice) / _purchasedTests.length,
    };
  }

  List<Map<String, dynamic>> getPurchaseHistory() {
    List<Map<String, dynamic>> history = [];
    
    for (var test in _purchasedTests) {
      history.add({
        'id': test.id,
        'title': test.title,
        'type': 'Test Series',
        'price': test.discountedPrice,
        'purchaseDate': DateTime.now().subtract(Duration(days: 30)), // Mock data
      });
    }
    
    for (var material in _purchasedMaterials) {
      history.add({
        'id': material.id,
        'title': material.title,
        'type': 'Study Material',
        'price': 0.0, // Assuming materials are free or bundled
        'purchaseDate': DateTime.now().subtract(Duration(days: 20)), // Mock data
      });
    }
    
    // Sort by purchase date
    history.sort((a, b) => (b['purchaseDate'] as DateTime).compareTo(a['purchaseDate']));
    
    return history;
  }
}