import 'package:flutter/material.dart';
import '../models/question.dart';
import '../utils/app_colors.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final int totalQuestions;
  final Function(String) onAnswerSelected;
  final VoidCallback onMarkForReview;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onAnswerSelected,
    required this.onMarkForReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionHeader(),
            SizedBox(height: 16),
            _buildQuestionText(),
            SizedBox(height: 20),
            _buildOptions(),
            SizedBox(height: 20),
            _buildQuestionActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Question $questionNumber of $totalQuestions',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getDifficultyColor(question.difficulty).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                question.difficulty,
                style: TextStyle(
                  color: _getDifficultyColor(question.difficulty),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                question.subject,
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionText() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        question.question,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;
        String optionLabel = String.fromCharCode(65 + index); // A, B, C, D
        bool isSelected = question.userAnswer == index.toString();
        
        return GestureDetector(
          onTap: () => onAnswerSelected(index.toString()),
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.divider,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.divider,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionLabel,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestionActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (question.isAnswered)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Answered',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (question.isMarkedForReview)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Marked',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        OutlinedButton(
          onPressed: onMarkForReview,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: question.isMarkedForReview
                  ? AppColors.warning
                  : AppColors.textSecondary,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                question.isMarkedForReview
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                size: 16,
                color: question.isMarkedForReview
                    ? AppColors.warning
                    : AppColors.textSecondary,
              ),
              SizedBox(width: 4),
              Text(
                question.isMarkedForReview
                    ? 'Unmark'
                    : 'Mark for Review',
                style: TextStyle(
                  fontSize: 12,
                  color: question.isMarkedForReview
                      ? AppColors.warning
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
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