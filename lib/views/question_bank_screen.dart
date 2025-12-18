import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../controllers/question_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/question_widget.dart';

class QuestionBankScreen extends StatelessWidget {
  final QuestionController questionController = Get.find<QuestionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.questionBank),
      body: Column(
        children: [
          _buildFiltersSection(),
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              final question = questionController.currentQuestion;
              if (question == null) {
                return _buildEmptyState();
              }
              return _buildQuestionView(question);
            }),
          ),
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Subjects',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Obx(() => Wrap(
            spacing: 8,
            runSpacing: 4,
            children: questionController.subjects.map((subject) {
              final isSelected = questionController.selectedSubjects.contains(subject);
              final hasAccess = questionController.hasAccessToSubject(subject);
              
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      subject,
                      style: TextStyle(
                        color: isSelected ? Colors.white : 
                                hasAccess ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    if (!hasAccess) ...[
                      SizedBox(width: 4),
                      Icon(
                        Icons.lock,
                        size: 14,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ],
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (!hasAccess) {
                    questionController.purchaseSubjectAccess(subject);
                  } else {
                    questionController.toggleSubjectFilter(subject);
                  }
                },
                selectedColor: AppColors.primary,
                backgroundColor: hasAccess ? null : Colors.grey[200],
                disabledColor: Colors.grey[200],
                checkmarkColor: Colors.white,
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search questions...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
        onChanged: (value) {
          questionController.updateSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildQuestionView(question) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        children: [
          _buildQuestionInfo(question),
          SizedBox(height: AppSizes.paddingMedium),
          QuestionWidget(
            question: question,
            onAnswerSelected: (index) => questionController.selectAnswer(index),
            showExplanation: true,
            isPracticeMode: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionInfo(question) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subject: ${question.subject}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Difficulty: ${question.difficulty}',
                  style: TextStyle(
                    color: _getDifficultyColor(question.difficulty),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final totalQuestions = questionController.filteredQuestions.length;
            final currentIndex = questionController.currentQuestionIndex.value;
            return Text(
              '${currentIndex + 1} of $totalQuestions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => ElevatedButton(
              onPressed: questionController.currentQuestionIndex.value > 0
                  ? () => questionController.previousQuestion()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: Text(AppStrings.previous),
            )),
          ),
          SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Obx(() {
              final totalQuestions = questionController.filteredQuestions.length;
              final currentIndex = questionController.currentQuestionIndex.value;
              
              return ElevatedButton(
                onPressed: currentIndex < totalQuestions - 1
                    ? () => questionController.nextQuestion()
                    : null,
                child: Text(AppStrings.next),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'No Questions Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Select subjects to practice questions',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.paddingLarge),
          ElevatedButton(
            onPressed: () {
              // Scroll to top to show filters
            },
            child: Text('Select Subjects'),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}