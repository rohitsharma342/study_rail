import 'package:flutter/material.dart';
import '../models/question_status.dart';
import '../utils/app_colors.dart';

class QuestionStatusIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: QuestionStatus.values.map((status) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: status.color,
                  border: Border.all(color: status.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: status.hasGreenDot
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12),
              Text(
                status.label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}