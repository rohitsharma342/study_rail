import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cbt_exam_controller.dart';
import '../utils/app_colors.dart';

class ExamTimerWidget extends StatelessWidget {
  final CbtExamController controller = Get.find<CbtExamController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _getTimerColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getTimerBorderColor(),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              controller.formattedTime,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTimerColor() {
    final session = controller.examSession;
    if (session == null) return AppColors.primary;
    
    final remainingMinutes = session.remainingTime / 60;
    
    if (remainingMinutes <= 5) {
      return AppColors.error;
    } else if (remainingMinutes <= 15) {
      return Colors.orange;
    } else {
      return AppColors.primary;
    }
  }

  Color _getTimerBorderColor() {
    final session = controller.examSession;
    if (session == null) return AppColors.primary;
    
    final remainingMinutes = session.remainingTime / 60;
    
    if (remainingMinutes <= 5) {
      return Colors.red.shade700;
    } else if (remainingMinutes <= 15) {
      return Colors.orange.shade700;
    } else {
      return AppColors.primary;
    }
  }
}