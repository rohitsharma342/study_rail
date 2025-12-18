import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../controllers/question_controller.dart';
import '../controllers/exam_controller.dart';
import '../controllers/subject_controller.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/question_card.dart';
import 'exam_screen.dart';

class QuestionBankScreen extends StatelessWidget {
  final QuestionController questionController = Get.put(QuestionController());
  final ExamController examController = Get.put(ExamController());
  final SubjectController subjectController = Get.put(SubjectController());

  @override
  Widget build(BuildContext context) {
    // Navigate to the new exam selection screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.off(() => ExamScreen());
    });

    return Scaffold(
      appBar: CustomAppBar(title: 'Question Bank'),
      body: Obx(
        () => questionController.isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildFilterSection(),
                  _buildProgressSection(),
                  Expanded(child: _buildQuestionSection()),
                  _buildNavigationSection(),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterSection() {
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
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search questions...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onChanged: (value) {
              questionController.updateSearchQuery(value);
            },
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Subjects', questionController.selectedSubjects.isEmpty, () {
                  questionController.clearFilters();
                }),
                ...AppConstants.subjects.map((subject) {
                  return _buildFilterChip(
                    subject,
                    questionController.selectedSubjects.contains(subject),
                    () {
                      questionController.toggleSubjectFilter(subject);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.grey[200],
        selectedColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: Obx(
        () => Column(
          children: [
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
                  'Marked',
                  questionController.markedForReviewCount.toString(),
                  AppColors.warning,
                ),
                _buildStatItem(
                  'Progress',
                  '${questionController.progressPercentage.toStringAsFixed(0)}%',
                  AppColors.primary,
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
                  'Try adjusting your filters',
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