import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_interface_controller.dart';
import '../utils/app_colors.dart';

class ExamNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamInterfaceController>();
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final currentQuestion = controller.currentQuestion;
        
        return Row(
          children: [
            // Previous Button
            ElevatedButton.icon(
              onPressed: controller.canGoPrevious ? () => controller.previousQuestion() : null,
              icon: Icon(Icons.arrow_back, size: 16),
              label: Text('Previous'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            
            SizedBox(width: 12),
            
            // Mark for Review Button
            OutlinedButton.icon(
              onPressed: () => controller.toggleMarkForReview(),
              icon: Icon(
                currentQuestion?.isMarkedForReview == true 
                    ? Icons.bookmark 
                    : Icons.bookmark_border,
                size: 16,
              ),
              label: Text(
                currentQuestion?.isMarkedForReview == true 
                    ? 'Unmark' 
                    : 'Mark for Review',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.purple,
                side: BorderSide(color: Colors.purple),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            
            SizedBox(width: 12),
            
            // Clear Answer Button
            if (currentQuestion?.isAnswered == true)
              OutlinedButton.icon(
                onPressed: () => controller.clearAnswer(),
                icon: Icon(Icons.clear, size: 16),
                label: Text('Clear'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            
            Spacer(),
            
            // Next Button or Submit Button
            if (controller.canGoNext)
              ElevatedButton.icon(
                onPressed: () => controller.nextQuestion(),
                icon: Icon(Icons.arrow_forward, size: 16),
                label: Text('Save & Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => controller.showSubmitConfirmation(),
                icon: Icon(Icons.send, size: 16),
                label: Text('Submit Exam'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
          ],
        );
      }),
    );
  }
}