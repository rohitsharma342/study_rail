import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cbt_exam_controller.dart';
import '../utils/app_colors.dart';

class ExamNavigationWidget extends StatelessWidget {
  final CbtExamController controller = Get.find<CbtExamController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.textSecondary.withOpacity(0.3))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            'Clear',
            Icons.clear,
            AppColors.error,
            controller.clearAnswer,
            enabled: controller.selectedAnswer.isNotEmpty,
          ),
          SizedBox(width: 12),
          _buildActionButton(
            controller.isCurrentQuestionMarked() ? 'Unmark' : 'Mark',
            controller.isCurrentQuestionMarked() ? Icons.bookmark : Icons.bookmark_border,
            Colors.purple,
            controller.markForReview,
          ),
          Spacer(),
          _buildNavigationButton(
            'Previous',
            Icons.arrow_back,
            controller.previousQuestion,
            enabled: controller.canGoPrevious(),
          ),
          SizedBox(width: 12),
          _buildNavigationButton(
            'Next',
            Icons.arrow_forward,
            controller.nextQuestion,
            enabled: controller.canGoNext(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.white : AppColors.textSecondary,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : AppColors.background,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: enabled ? 2 : 0,
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.white : AppColors.textSecondary,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.primary : AppColors.background,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: enabled ? 2 : 0,
        ),
      ),
    );
  }
}