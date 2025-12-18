import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/constants.dart';
import 'utils/routes.dart';
import 'views/splash_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/test_controller.dart';
import 'controllers/question_controller.dart';
import 'controllers/study_material_controller.dart';

void main() {
  runApp(StudyRailApp());
}

class StudyRailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Study Rail',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(TestController());
        Get.put(QuestionController());
        Get.put(StudyMaterialController());
      }),
      home: SplashScreen(),
      getPages: AppRoutes.routes,
    );
  }
}