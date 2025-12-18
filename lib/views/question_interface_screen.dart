import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../controllers/question_controller.dart';
import '../controllers/subject_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_feedback_widget.dart';

class QuestionInterfaceScreen extends StatelessWidget {
  final QuestionController questionController = Get.find<QuestionController>();
  final SubjectController subjectController = Get.find<SubjectController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: subjectController.selectedSubject?.name ?? 'Questions',
        showBackButton: true,
      ),
      body: Obx(
        () => questionController.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildProgressSection(),
                  Expanded(child: _buildQuestionSection()),
                  _buildNavigationSection(),
                ],
              ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.quiz,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  subjectController.selectedSubject?.name ?? 'Questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearPercentIndicator(
              width: Get.width - 32,
              lineHeight: 8,
              percent: questionController.progressPercentage / 100,
              backgroundColor: Colors.grey[300],
              progressColor: AppColors.primary,
              barRadius: Radius.circular(4),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  'Total',
                  questionController.filteredQuestions.length.toString(),
                  AppColors.textSecondary,
                ),
                _buildStatItem(
                  'Answered',
                  questionController.answeredCount.toString(),
                  AppColors.success,
                ),
                _buildStatItem(
                  'Correct',
                  questionController.correctAnswersCount.toString(),
                  AppColors.primary,
                ),
                _buildStatItem(
                  'Progress',
                  '${questionController.progressPercentage.toStringAsFixed(0)}%',
                  AppColors.warning,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionSection() {
    return Obx(
      () {
        final question = questionController.currentQuestion;
        
        if (question == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'No questions found',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try selecting a different subject',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              QuestionCard(
                question: question,
                questionNumber: questionController.currentQuestionIndex + 1,
                totalQuestions: questionController.filteredQuestions.length,
                onAnswerSelected: (answer) {
                  questionController.selectAnswer(answer);
                  // Refresh subject progress when answer is selected
                  subjectController.refreshProgress();
                },
                onMarkForReview: () {
                  questionController.toggleMarkForReview();
                },
              ),
              AnswerFeedbackWidget(
                question: question,
                showFeedback: question.isAnswered,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationSection() {
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
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: questionController.currentQuestionIndex > 0
                    ? () => questionController.previousQuestion()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 16),
                    SizedBox(width: 4),
                    Text('Previous'),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${questionController.currentQuestionIndex + 1} / ${questionController.filteredQuestions.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: questionController.currentQuestionIndex < 
                        questionController.filteredQuestions.length - 1
                    ? () => questionController.nextQuestion()
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next'),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}