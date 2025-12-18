import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/exam_session.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_app_bar.dart';

class ExamResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExamSession examSession = Get.arguments['examSession'];
    
    return Scaffold(
      appBar: CustomAppBar(title: 'Exam Results'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultHeader(examSession),
            SizedBox(height: 24),
            _buildScoreCard(examSession),
            SizedBox(height: 24),
            _buildDetailedAnalysis(examSession),
            SizedBox(height: 24),
            _buildTimeAnalysis(examSession),
            SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader(ExamSession session) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Exam Completed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            session.testTitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Submitted on ${_formatDateTime(session.endTime ?? DateTime.now())}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(ExamSession session) {
    final score = _calculateScore(session);
    final percentage = (score / session.totalQuestions * 100);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Score',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                score.toString(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(percentage),
                ),
              ),
              Text(
                ' / ${session.totalQuestions}',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _getScoreColor(percentage),
            ),
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(percentage)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedAnalysis(ExamSession session) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          _buildAnalysisRow('Total Questions', session.totalQuestions.toString(), AppColors.primary),
          _buildAnalysisRow('Correct Answers', _calculateScore(session).toString(), AppColors.success),
          _buildAnalysisRow('Wrong Answers', _calculateWrongAnswers(session).toString(), AppColors.error),
          _buildAnalysisRow('Not Attempted', session.notVisitedCount.toString(), AppColors.textSecondary),
          _buildAnalysisRow('Marked for Review', session.markedCount.toString(), Colors.purple),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAnalysis(ExamSession session) {
    final timeSpent = session.totalDuration - session.remainingTime;
    final timeSpentFormatted = _formatDuration(timeSpent);
    final totalTimeFormatted = _formatDuration(session.totalDuration);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time Spent',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                timeSpentFormatted,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Time',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                totalTimeFormatted,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: timeSpent / session.totalDuration,
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.dashboard);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Back to Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.liveTests);
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Take Another Test',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _calculateScore(ExamSession session) {
    int score = 0;
    for (int i = 0; i < session.questions.length; i++) {
      final question = session.questions[i];
      final userAnswer = session.userAnswers[question.id];
      if (userAnswer != null && userAnswer == question.correctAnswer.toString()) {
        score++;
      }
    }
    return score;
  }

  int _calculateWrongAnswers(ExamSession session) {
    int wrong = 0;
    for (int i = 0; i < session.questions.length; i++) {
      final question = session.questions[i];
      final userAnswer = session.userAnswers[question.id];
      if (userAnswer != null && userAnswer != question.correctAnswer.toString()) {
        wrong++;
      }
    }
    return wrong;
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) {
      return AppColors.success;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return AppColors.error;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
}