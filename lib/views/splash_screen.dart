import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(AppConstants.splashDuration);
    
    if (authController.isLoggedIn) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.train,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Railway Exam Preparation',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 40),
                    SpinKitWave(
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppConstants.tagline,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppConstants.copyright,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}