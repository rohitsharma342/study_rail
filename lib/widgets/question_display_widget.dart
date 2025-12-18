import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cbt_exam_controller.dart';
import '../models/question.dart';
import '../utils/app_colors.dart';

class QuestionDisplayWidget extends StatelessWidget {
  final CbtExamController controller = Get.find<CbtExamController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.currentQuestion != null
          ? Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionHeader(),
                  SizedBox(height: 24),
                  _buildQuestionText(),
                  SizedBox(height: 32),
                  _buildOptions(),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.quiz,
            color: AppColors.primary,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Question ${controller.currentQuestionIndex + 1} of ${controller.totalQuestions}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          Spacer(),
          if (controller.currentQuestion?.subject != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                controller.currentQuestion!.subject,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionText() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        controller.currentQuestion?.question ?? '',
        style: TextStyle(
          fontSize: 18,
          height: 1.6,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOptions() {
    final question = controller.currentQuestion;
    if (question == null) return SizedBox.shrink();

    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
        final isSelected = controller.selectedAnswer == index.toString();

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildOptionTile(optionLabel, option, index.toString(), isSelected),
        );
      }).toList(),
    );
  }

  Widget _buildOptionTile(String label, String text, String value, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectAnswer(value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}