import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cbt_exam_controller.dart';
import '../models/question_status.dart';
import '../utils/app_colors.dart';

class QuestionPaletteWidget extends StatelessWidget {
  final CbtExamController controller = Get.find<CbtExamController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: controller.showQuestionPalette ? 320 : 0,
        height: double.infinity,
        child: controller.showQuestionPalette
            ? Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildLegend(),
                    _buildQuestionGrid(),
                    _buildSummary(),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question Palette',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: controller.hideQuestionPalette,
            icon: Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: QuestionStatus.values.map((status) {
              return _buildLegendItem(status);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(QuestionStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: status.color,
            border: Border.all(color: status.borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: status.hasGreenDot
              ? Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(width: 4),
        Text(
          status.label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionGrid() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: controller.totalQuestions,
          itemBuilder: (context, index) {
            return _buildQuestionButton(index);
          },
        ),
      ),
    );
  }

  Widget _buildQuestionButton(int index) {
    final status = controller.getQuestionStatus(index);
    final isCurrentQuestion = index == controller.currentQuestionIndex;
    
    return GestureDetector(
      onTap: () => controller.jumpToQuestion(index),
      child: Container(
        decoration: BoxDecoration(
          color: status.color,
          border: Border.all(
            color: isCurrentQuestion ? Colors.black : status.borderColor,
            width: isCurrentQuestion ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: status.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (status.hasGreenDot)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.textSecondary.withOpacity(0.3))),
      ),
      child: Obx(
        () => Column(
          children: [
            _buildSummaryRow('Answered', controller.examSession?.answeredCount ?? 0, AppColors.success),
            _buildSummaryRow('Not Answered', controller.examSession?.notAnsweredCount ?? 0, AppColors.error),
            _buildSummaryRow('Marked', controller.examSession?.markedCount ?? 0, Colors.purple),
            _buildSummaryRow('Not Visited', controller.examSession?.notVisitedCount ?? 0, AppColors.textSecondary),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.showSubmitConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Submit Exam',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, int count, Color color) {
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}