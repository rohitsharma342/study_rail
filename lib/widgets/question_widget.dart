import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionModel question;
  final Function(int) onAnswerSelected;
  final VoidCallback? onMarkForReview;
  final bool showExplanation;
  final bool isPracticeMode;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    this.onMarkForReview,
    this.showExplanation = false,
    this.isPracticeMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionCard(),
          SizedBox(height: AppSizes.paddingMedium),
          _buildOptionsCard(),
          if (onMarkForReview != null) ...[
            SizedBox(height: AppSizes.paddingMedium),
            _buildMarkForReviewButton(),
          ],
          if (showExplanation && question.isAnswered && isPracticeMode) ...[
            SizedBox(height: AppSizes.paddingMedium),
            _buildExplanationCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              question.question,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSizes.paddingMedium),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return _buildOptionTile(index, option);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(int index, String option) {
    final isSelected = question.selectedAnswer == index.toString();
    final isCorrect = index == question.correctAnswer;
    final showCorrectAnswer = showExplanation && question.isAnswered && isPracticeMode;
    
    Color? backgroundColor;
    Color? borderColor;
    
    if (showCorrectAnswer) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withOpacity(0.1);
        borderColor = AppColors.success;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.error.withOpacity(0.1);
        borderColor = AppColors.error;
      }
    } else if (isSelected) {
      backgroundColor = AppColors.primary.withOpacity(0.1);
      borderColor = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.paddingSmall),
      child: InkWell(
        onTap: () => onAnswerSelected(index),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Container(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor ?? Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? Colors.grey,
                    width: 2,
                  ),
                  color: isSelected ? (borderColor ?? AppColors.primary) : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(width: AppSizes.paddingMedium),
              Expanded(
                child: Text(
                  '${String.fromCharCode(65 + index)}. $option',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (showCorrectAnswer && isCorrect)
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
              if (showCorrectAnswer && isSelected && !isCorrect)
                Icon(
                  Icons.cancel,
                  color: AppColors.error,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkForReviewButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onMarkForReview,
        icon: Icon(
          question.isMarkedForReview ? Icons.bookmark : Icons.bookmark_border,
          color: question.isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
        ),
        label: Text(
          question.isMarkedForReview ? 'Marked for Review' : 'Mark for Review',
          style: TextStyle(
            color: question.isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: question.isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
          ),
          backgroundColor: question.isMarkedForReview 
              ? AppColors.warning.withOpacity(0.1) 
              : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        decoration: BoxDecoration(
          color: question.isCorrect 
              ? AppColors.success.withOpacity(0.05)
              : AppColors.error.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  question.isCorrect ? Icons.check_circle : Icons.cancel,
                  color: question.isCorrect ? AppColors.success : AppColors.error,
                ),
                SizedBox(width: AppSizes.paddingSmall),
                Text(
                  question.isCorrect ? 'Correct Answer!' : 'Incorrect Answer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: question.isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            if (!question.isCorrect) ...[
              SizedBox(height: AppSizes.paddingSmall),
              Text(
                'Correct answer: ${String.fromCharCode(65 + question.correctAnswer)}. ${question.options[question.correctAnswer]}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Explanation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              question.explanation,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}