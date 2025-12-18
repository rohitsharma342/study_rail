import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/static_data.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;

  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      if (isLoggedIn) {
        _currentUser.value = StaticData.currentUser;
        _isLoggedIn.value = true;
      }
    } catch (e) {
      print('Error checking login status: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading.value = true;
    
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      
      // Simple validation for demo
      if (email.contains('@railway.gov.in') && password.length >= 6) {
        _currentUser.value = StaticData.currentUser;
        _isLoggedIn.value = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        
        Get.offAllNamed(AppRoutes.dashboard);
        Get.snackbar('Success', 'Login successful!');
        return true;
      } else {
        Get.snackbar('Error', 'Invalid credentials');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed. Please try again.');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    _isLoading.value = true;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      
      _currentUser.value = null;
      _isLoggedIn.value = false;
      
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Logout failed');
    } finally {
      _isLoading.value = false;
    }
  }
}