import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/subject.dart';
import '../utils/app_colors.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getSubjectColor().withOpacity(0.1),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subject.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    subject.totalQuestions.toString(),
                    AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    subject.completedQuestions.toString(),
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Progress',
                    '${subject.progressPercentage.toStringAsFixed(0)}%',
                    AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 72,
              lineHeight: 6,
              percent: subject.progressPercentage / 100,
              backgroundColor: Colors.grey[200],
              progressColor: _getSubjectColor(),
              barRadius: Radius.circular(3),
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
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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