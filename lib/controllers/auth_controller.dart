import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/data_service.dart';

class AuthController extends GetxController {
  final DataService _dataService = DataService();
  
  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;

  UserModel? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      
      if (userId != null) {
        final userData = _dataService.getUserData();
        _user.value = UserModel.fromJson(userData);
        isLoggedIn.value = true;
      }
    } catch (e) {
      print('Error checking login status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 1));
      
      if (email == 'user@studyrail.com' && password == 'password') {
        final userData = _dataService.getUserData();
        _user.value = UserModel.fromJson(userData);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userData['id']);
        
        isLoggedIn.value = true;
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _user.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      print('Logout error: $e');
    }
  }

  void purchaseTest(String testId) {
    if (_user.value != null) {
      final updatedPurchases = List<String>.from(_user.value!.purchasedTests);
      if (!updatedPurchases.contains(testId)) {
        updatedPurchases.add(testId);
        _user.value = _user.value!.copyWith(
          purchasedTests: updatedPurchases,
        );
      }
    }
  }

  void purchaseSubject(String subject) {
    if (_user.value != null) {
      final updatedSubjects = List<String>.from(_user.value!.purchasedSubjects);
      if (!updatedSubjects.contains(subject)) {
        updatedSubjects.add(subject);
        _user.value = _user.value!.copyWith(
          purchasedSubjects: updatedSubjects,
        );
      }
    }
  }
}