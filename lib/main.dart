import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/app_colors.dart';
import 'utils/app_routes.dart';
import 'views/splash_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/test_controller.dart';
import 'controllers/question_controller.dart';
import 'controllers/purchase_controller.dart';

void main() {
  runApp(StudyRailApp());
}

class StudyRailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Study Rail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0020BD, {
          50: Color(0xFFE6E9FF),
          100: Color(0xFFB3BFFF),
          200: Color(0xFF8095FF),
          300: Color(0xFF4D6BFF),
          400: Color(0xFF2646FF),
          500: Color(0xFF0020BD),
          600: Color(0xFF001DA6),
          700: Color(0xFF001A8F),
          800: Color(0xFF001778),
          900: Color(0xFF001461),
        }),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(TestController());
        Get.put(QuestionController());
        Get.put(PurchaseController());
      }),
      home: SplashScreen(),
    );
  }
}