import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/live_tests_screen.dart';
import '../views/question_bank_screen.dart';
import '../views/study_material_screen.dart';
import '../views/my_purchases_screen.dart';
import '../views/login_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String liveTests = '/live-tests';
  static const String questionBank = '/question-bank';
  static const String studyMaterial = '/study-material';
  static const String myPurchases = '/my-purchases';

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
    GetPage(name: liveTests, page: () => LiveTestsScreen()),
    GetPage(name: questionBank, page: () => QuestionBankScreen()),
    GetPage(name: studyMaterial, page: () => StudyMaterialScreen()),
    GetPage(name: myPurchases, page: () => MyPurchasesScreen()),
  ];
}