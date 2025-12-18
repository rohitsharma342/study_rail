import 'package:get/get.dart';
import '../views/splash_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/live_tests_screen.dart';
import '../views/question_bank_screen.dart';
import '../views/study_material_screen.dart';
import '../views/my_purchases_screen.dart';
import '../views/login_screen.dart';
import '../views/subject_list_screen.dart';
import '../views/question_interface_screen.dart';
import '../views/exam_screen.dart';
import '../views/subject_screen.dart';
import '../views/leaderboard_screen.dart';
import '../views/exam_interface_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String liveTests = '/live-tests';
  static const String questionBank = '/question-bank';
  static const String examScreen = '/exam-screen';
  static const String subjectScreen = '/subject-screen';
  static const String subjectList = '/subject-list';
  static const String questionInterface = '/question-interface';
  static const String studyMaterial = '/study-material';
  static const String myPurchases = '/my-purchases';
  static const String leaderboard = '/leaderboard';
  static const String examInterface = '/exam-interface';

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
    GetPage(name: liveTests, page: () => LiveTestsScreen()),
    GetPage(name: questionBank, page: () => QuestionBankScreen()),
    GetPage(name: examScreen, page: () => ExamScreen()),
    GetPage(name: subjectScreen, page: () => SubjectScreen()),
    GetPage(name: subjectList, page: () => SubjectListScreen()),
    GetPage(name: questionInterface, page: () => QuestionInterfaceScreen()),
    GetPage(name: studyMaterial, page: () => StudyMaterialScreen()),
    GetPage(name: myPurchases, page: () => MyPurchasesScreen()),
    GetPage(name: leaderboard, page: () => LeaderboardScreen()),
    GetPage(name: examInterface, page: () => ExamInterfaceScreen()),
  ];
}