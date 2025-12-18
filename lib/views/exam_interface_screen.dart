import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_interface_controller.dart';
import '../models/exam.dart';
import '../utils/app_colors.dart';
import '../utils/exam_constants.dart';
import '../widgets/exam_timer.dart';
import '../widgets/question_palette.dart';
import '../widgets/exam_navigation_bar.dart';
import '../widgets/mcq_option_widget.dart';
import '../widgets/question_status_indicator.dart';

class ExamInterfaceScreen extends StatelessWidget {
  final ExamInterfaceController controller = Get.put(ExamInterfaceController());
  final Exam exam = Get.arguments as Exam;

  @override
  Widget build(BuildContext context) {
    // Initialize exam when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isExamStarted && !controller.isLoading) {
        controller.initializeExam(exam);
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (controller.isExamStarted && !controller.isExamCompleted) {
          Get.dialog(
            AlertDialog(
              title: Text('Exit Exam'),
              content: Text('Are you sure you want to exit the exam? Your progress will be lost.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text('Exit'),
                ),
              ],
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (controller.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading exam questions...'),
                ],
              ),
            );
          }

          if (!controller.isExamStarted) {
            return _buildExamInstructions();
          }

          return _buildExamInterface();
        }),
      ),
    );
  }

  Widget _buildExamInstructions() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Duration: ${exam.duration} minutes | Questions: ${exam.totalQuestions}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          Divider(),
          
          // Instructions
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXAMINATION INSTRUCTIONS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      ExamConstants.examInstructions,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Question Status Legend
                    Text(
                      'QUESTION STATUS LEGEND',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 12),
                    QuestionStatusIndicator(),
                  ],
                ),
              ),
            ),
          ),
          
          // Start Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () => controller.startExam(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'START EXAMINATION',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamInterface() {
    return Column(
      children: [
        // Top Bar with Timer and Info
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  exam.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ExamTimer(),
              SizedBox(width: 16),
              IconButton(
                onPressed: () => controller.toggleQuestionPalette(),
                icon: Icon(
                  controller.isPaletteVisible ? Icons.close : Icons.grid_view,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        
        // Main Content
        Expanded(
          child: Row(
            children: [
              // Question Area
              Expanded(
                flex: controller.isPaletteVisible ? 3 : 1,
                child: _buildQuestionArea(),
              ),
              
              // Question Palette (if visible)
              if (controller.isPaletteVisible)
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(-2, 0),
                      ),
                    ],
                  ),
                  child: QuestionPalette(),
                ),
            ],
          ),
        ),
        
        // Bottom Navigation
        ExamNavigationBar(),
      ],
    );
  }

  Widget _buildQuestionArea() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Obx(() {
        final currentQuestion = controller.currentQuestion;
        if (currentQuestion == null) {
          return Center(child: Text('No question available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Question ${controller.currentQuestionIndex + 1} of ${controller.examQuestions.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Spacer(),
                  if (currentQuestion.isMarkedForReview)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Marked for Review',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Question Text
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQuestion.question.questionText,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          if (currentQuestion.question.imageUrl != null) ..[
                            SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                currentQuestion.question.imageUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: AppColors.background,
                                    child: Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          
                          SizedBox(height: 24),
                          
                          // MCQ Options
                          ...currentQuestion.question.options.asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value;
                            final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
                            
                            return MCQOptionWidget(
                              label: optionLabel,
                              text: option,
                              isSelected: currentQuestion.selectedAnswer == option,
                              onTap: () => controller.selectAnswer(option),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}