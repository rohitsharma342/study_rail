import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cbt_exam_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/exam_header_widget.dart';
import '../widgets/question_display_widget.dart';
import '../widgets/question_palette_widget.dart';
import '../widgets/exam_navigation_widget.dart';

class CbtExamScreen extends StatelessWidget {
  final CbtExamController controller = Get.put(CbtExamController());

  @override
  Widget build(BuildContext context) {
    // Get test ID from arguments
    final String testId = Get.arguments['testId'] ?? '';
    
    // Start exam when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (testId.isNotEmpty) {
        controller.startExam(testId);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ExamHeaderWidget(),
        body: Obx(
          () => controller.isLoading
              ? _buildLoadingScreen()
              : Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: QuestionDisplayWidget(),
                              ),
                              ExamNavigationWidget(),
                            ],
                          ),
                        ),
                        QuestionPaletteWidget(),
                      ],
                    ),
                    if (controller.showSubmitDialog)
                      _buildSubmitDialog(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 24),
            Text(
              'Preparing your exam...',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please wait while we load your questions',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitDialog(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(32),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                'Submit Exam?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Are you sure you want to submit your exam? You cannot change your answers after submission.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24),
              Obx(
                () => Column(
                  children: [
                    _buildSummaryRow('Total Questions', controller.totalQuestions.toString()),
                    _buildSummaryRow('Answered', (controller.examSession?.answeredCount ?? 0).toString()),
                    _buildSummaryRow('Not Answered', (controller.examSession?.notAnsweredCount ?? 0).toString()),
                    _buildSummaryRow('Marked for Review', (controller.examSession?.markedCount ?? 0).toString()),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: controller.hideSubmitConfirmation,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.submitExam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Exit Exam?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to exit the exam? Your progress will be lost.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Exit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}