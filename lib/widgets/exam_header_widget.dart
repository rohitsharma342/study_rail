import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cbt_exam_controller.dart';
import '../utils/app_colors.dart';
import 'exam_timer_widget.dart';

class ExamHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final CbtExamController controller = Get.find<CbtExamController>();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        onPressed: () => _showExitConfirmation(context),
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      title: Obx(
        () => Text(
          controller.examSession?.testTitle ?? 'CBT Exam',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        ExamTimerWidget(),
        SizedBox(width: 8),
        IconButton(
          onPressed: controller.toggleQuestionPalette,
          icon: Obx(
            () => Icon(
              controller.showQuestionPalette ? Icons.close : Icons.grid_view,
              color: AppColors.primary,
            ),
          ),
          tooltip: 'Question Palette',
        ),
        IconButton(
          onPressed: controller.showSubmitConfirmation,
          icon: Icon(Icons.send, color: AppColors.error),
          tooltip: 'Submit Exam',
        ),
        SizedBox(width: 8),
      ],
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