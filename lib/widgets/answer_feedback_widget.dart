import 'package:flutter/material.dart';
import '../models/question.dart';
import '../utils/app_colors.dart';

class AnswerFeedbackWidget extends StatelessWidget {
  final Question question;
  final bool showFeedback;

  const AnswerFeedbackWidget({
    Key? key,
    required this.question,
    required this.showFeedback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showFeedback || !question.isAnswered) {
      return SizedBox.shrink();
    }

    final isCorrect = question.isCorrect;
    final correctAnswer = question.correctAnswer;
    final correctOption = correctAnswer is int && correctAnswer >= 0 && correctAnswer < question.options.length
        ? question.options[correctAnswer]
        : 'N/A';
    
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? AppColors.success : AppColors.error,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCorrect ? AppColors.success : AppColors.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Correct Answer!' : 'Incorrect Answer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCorrect ? AppColors.success : AppColors.error,
                      ),
                    ),
                    if (!isCorrect) ..._buildIncorrectAnswerInfo(correctAnswer, correctOption),
                  ],
                ),
              ),
            ],
          ),
          if (question.explanation.isNotEmpty) ..._buildExplanation(),
        ],
      ),
    );
  }

  List<Widget> _buildIncorrectAnswerInfo(dynamic correctAnswer, String correctOption) {
    final answerLabel = correctAnswer is int && correctAnswer >= 0
        ? String.fromCharCode(65 + correctAnswer)
        : 'N/A';
    
    return [
      SizedBox(height: 4),
      Text(
        'Correct answer: $answerLabel. $correctOption',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    ];
  }

  List<Widget> _buildExplanation() {
    return [
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.warning,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Explanation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              question.explanation,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}