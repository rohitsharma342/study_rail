import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_interface_controller.dart';
import '../models/question_status.dart';
import '../utils/app_colors.dart';
import 'question_status_indicator.dart';

class QuestionPalette extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamInterfaceController>();
    
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question Palette',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => controller.hideQuestionPalette(),
                icon: Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Status Summary
          Obx(() {
            final statusCounts = controller.questionStatusCounts;
            return Column(
              children: QuestionStatus.values.map((status) {
                final count = statusCounts[status] ?? 0;
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: status.color,
                          border: Border.all(color: status.borderColor),
                          borderRadius: BorderRadius.circular(3),
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
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          status.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
          
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          
          // Question Grid
          Expanded(
            child: Obx(() {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: controller.examQuestions.length,
                itemBuilder: (context, index) {
                  final examQuestion = controller.examQuestions[index];
                  final isCurrentQuestion = index == controller.currentQuestionIndex;
                  
                  return GestureDetector(
                    onTap: () {
                      controller.goToQuestion(index);
                      controller.hideQuestionPalette();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: examQuestion.status.color,
                        border: Border.all(
                          color: isCurrentQuestion 
                              ? AppColors.primary 
                              : examQuestion.status.borderColor,
                          width: isCurrentQuestion ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: examQuestion.status == QuestionStatus.notVisited
                                    ? AppColors.textPrimary
                                    : Colors.white,
                              ),
                            ),
                          ),
                          if (examQuestion.status.hasGreenDot)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 6,
                                height: 6,
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
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}