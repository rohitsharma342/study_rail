import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/subject.dart';
import '../controllers/question_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/question_card.dart';

class SubjectQuestionsScreen extends StatelessWidget {
  final Subject subject;
  final QuestionController questionController = Get.find<QuestionController>();

  SubjectQuestionsScreen({Key? key, required this.subject}) : super(key: key) {
    // Filter questions by subject when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionController.filterQuestionsBySubject(subject.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: subject.name,
        showBackButton: true,
      ),
      body: Obx(
        () => questionController.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildSubjectHeader(),
                  _buildProgressSection(),
                  Expanded(child: _buildQuestionSection()),
                  _buildNavigationSection(),
                ],
              ),
      ),
    );
  }

  Widget _buildSubjectHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getSubjectColor().withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getSubjectColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getSubjectIcon(),
              color: _getSubjectColor(),
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subject.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            LinearPercentIndicator(
              width: Get.width - 32,
              lineHeight: 8,
              percent: questionController.progressPercentage / 100,
              backgroundColor: Colors.grey[300],
              progressColor: _getSubjectColor(),
              barRadius: Radius.circular(4),
            ),
            SizedBox(height: 12),
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
                  'Marked',
                  questionController.markedForReviewCount.toString(),
                  AppColors.warning,
                ),
                _buildStatItem(
                  'Progress',
                  '${questionController.progressPercentage.toStringAsFixed(0)}%',
                  _getSubjectColor(),
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
                  Icons.quiz_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'No questions available',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Questions for this subject will be added soon',
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
          child: QuestionCard(
            question: question,
            questionNumber: questionController.currentQuestionIndex + 1,
            totalQuestions: questionController.filteredQuestions.length,
            onAnswerSelected: (answer) {
              questionController.selectAnswer(answer);
            },
            onMarkForReview: () {
              questionController.toggleMarkForReview();
            },
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Previous',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getSubjectColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getSubjectColor().withOpacity(0.3),
                ),
              ),
              child: Text(
                '${questionController.currentQuestionIndex + 1} / ${questionController.filteredQuestions.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getSubjectColor(),
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
                  backgroundColor: _getSubjectColor(),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor() {
    switch (subject.name.toLowerCase()) {
      case 'operating procedures':
        return AppColors.primary;
      case 'safety rules':
        return AppColors.error;
      case 'technical knowledge':
        return AppColors.secondary;
      case 'commercial rules':
        return AppColors.success;
      case 'general knowledge':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _getSubjectIcon() {
    switch (subject.name.toLowerCase()) {
      case 'operating procedures':
        return Icons.settings;
      case 'safety rules':
        return Icons.security;
      case 'technical knowledge':
        return Icons.engineering;
      case 'commercial rules':
        return Icons.business;
      case 'general knowledge':
        return Icons.school;
      default:
        return Icons.book;
    }
  }
}