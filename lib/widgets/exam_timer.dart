import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_interface_controller.dart';
import '../utils/app_colors.dart';

class ExamTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamInterfaceController>();
    
    return Obx(() {
      final remainingSeconds = controller.remainingTimeInSeconds;
      final isWarning = remainingSeconds <= 900; // 15 minutes
      final isCritical = remainingSeconds <= 300; // 5 minutes
      
      Color timerColor = AppColors.success;
      if (isCritical) {
        timerColor = AppColors.error;
      } else if (isWarning) {
        timerColor = AppColors.warning;
      }
      
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: timerColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: timerColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer,
              color: timerColor,
              size: 18,
            ),
            SizedBox(width: 6),
            Text(
              controller.formattedTime,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: timerColor,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      );
    });
  }
}