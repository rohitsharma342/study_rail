import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum QuestionStatus {
  notVisited,
  notAnswered,
  answered,
  markedForReview,
  answeredAndMarked,
}

extension QuestionStatusExtension on QuestionStatus {
  Color get color {
    switch (this) {
      case QuestionStatus.notVisited:
        return Colors.white;
      case QuestionStatus.notAnswered:
        return AppColors.error;
      case QuestionStatus.answered:
        return AppColors.success;
      case QuestionStatus.markedForReview:
        return Colors.purple;
      case QuestionStatus.answeredAndMarked:
        return Colors.purple;
    }
  }

  Color get borderColor {
    switch (this) {
      case QuestionStatus.notVisited:
        return Colors.grey;
      case QuestionStatus.notAnswered:
        return AppColors.error;
      case QuestionStatus.answered:
        return AppColors.success;
      case QuestionStatus.markedForReview:
        return Colors.purple;
      case QuestionStatus.answeredAndMarked:
        return Colors.purple;
    }
  }

  String get label {
    switch (this) {
      case QuestionStatus.notVisited:
        return 'Not Visited';
      case QuestionStatus.notAnswered:
        return 'Not Answered';
      case QuestionStatus.answered:
        return 'Answered';
      case QuestionStatus.markedForReview:
        return 'Marked for Review';
      case QuestionStatus.answeredAndMarked:
        return 'Answered & Marked';
    }
  }

  bool get hasGreenDot => this == QuestionStatus.answeredAndMarked;
}