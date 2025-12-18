import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/study_material_model.dart';
import '../services/data_service.dart';
import 'auth_controller.dart';

class StudyMaterialController extends GetxController {
  final DataService _dataService = DataService();
  final AuthController authController = Get.find<AuthController>();
  
  final RxList<StudyMaterialModel> materials = <StudyMaterialModel>[].obs;
  final RxList<String> subjects = <String>[].obs;
  final RxString selectedSubject = ''.obs;
  final RxString selectedTab = 'Videos'.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubjects();
    loadMaterials();
  }

  void loadSubjects() {
    subjects.value = _dataService.getSubjects();
    if (subjects.isNotEmpty) {
      selectedSubject.value = subjects.first;
    }
  }

  void loadMaterials() {
    final materialData = _dataService.getStudyMaterialData();
    materials.value = materialData.map((data) => StudyMaterialModel.fromJson(data)).toList();
  }

  List<StudyMaterialModel> get filteredMaterials {
    return materials.where((material) {
      // Filter by selected subject
      if (selectedSubject.value.isNotEmpty && 
          material.subject != selectedSubject.value) {
        return false;
      }
      
      // Filter by selected tab (content type)
      String tabType = selectedTab.value.toLowerCase();
      if (tabType == 'videos' && material.type != 'video') return false;
      if (tabType == 'documents' && material.type != 'document') return false;
      if (tabType == 'tests' && material.type != 'test') return false;
      
      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        return material.title.toLowerCase()
            .contains(searchQuery.value.toLowerCase()) ||
            material.description.toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }
      
      return true;
    }).toList();
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void playVideo(StudyMaterialModel material) {
    if (!hasAccessToMaterial(material)) {
      showPurchaseDialog(material.subject);
      return;
    }
    
    // Simulate video playback
    Get.snackbar(
      'Playing Video',
      material.title,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewDocument(StudyMaterialModel material) {
    if (!hasAccessToMaterial(material)) {
      showPurchaseDialog(material.subject);
      return;
    }
    
    // Simulate document viewing
    Get.snackbar(
      'Opening Document',
      material.title,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void downloadMaterial(StudyMaterialModel material) {
    if (!hasAccessToMaterial(material)) {
      showPurchaseDialog(material.subject);
      return;
    }
    
    // Simulate download
    Get.snackbar(
      'Download Started',
      '${material.title} is being downloaded...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void downloadAllTests() {
    if (!hasAccessToSubject(selectedSubject.value)) {
      showPurchaseDialog(selectedSubject.value);
      return;
    }
    
    final testMaterials = filteredMaterials
        .where((material) => material.type == 'test')
        .toList();
    
    if (testMaterials.isEmpty) {
      Get.snackbar(
        'No Tests Found',
        'No test materials available for download.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    Get.snackbar(
      'Download Started',
      'Downloading ${testMaterials.length} test files...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool hasAccessToMaterial(StudyMaterialModel material) {
    return material.isPurchased || hasAccessToSubject(material.subject);
  }

  bool hasAccessToSubject(String subject) {
    return authController.user?.hasAccessToSubject(subject) ?? false;
  }

  void showPurchaseDialog(String subject) {
    Get.dialog(
      AlertDialog(
        title: Text('Purchase Required'),
        content: Text('You need to purchase access to $subject materials to view this content.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              purchaseSubjectAccess(subject);
              Get.back();
            },
            child: Text('Purchase'),
          ),
        ],
      ),
    );
  }

  void purchaseSubjectAccess(String subject) {
    authController.purchaseSubject(subject);
    loadMaterials(); // Refresh materials to update access status
    
    Get.snackbar(
      'Success',
      'Access to $subject materials purchased successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<String> get availableTabs => ['Videos', 'Documents', 'Tests'];
}