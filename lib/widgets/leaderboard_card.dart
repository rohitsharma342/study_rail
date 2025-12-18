import 'package:flutter/material.dart';
import '../models/leaderboard.dart';
import '../utils/app_colors.dart';

class LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardCard({
    Key? key,
    required this.entry,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser 
            ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildRankBadge(),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isCurrentUser)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${entry.designation} • ${entry.department}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    entry.testTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.score,
                        '${entry.score}/${entry.totalQuestions}',
                        AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.percent,
                        '${entry.percentage.toStringAsFixed(1)}%',
                        _getPercentageColor(entry.percentage),
                      ),
                      SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.timer,
                        entry.formattedTime,
                        AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    Color badgeColor;
    IconData? icon;
    
    if (entry.rank == 1) {
      badgeColor = Color(0xFFFFD700); // Gold
      icon = Icons.emoji_events;
    } else if (entry.rank == 2) {
      badgeColor = Color(0xFFC0C0C0); // Silver
      icon = Icons.emoji_events;
    } else if (entry.rank == 3) {
      badgeColor = Color(0xFFCD7F32); // Bronze
      icon = Icons.emoji_events;
    } else {
      badgeColor = AppColors.background;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: entry.rank <= 3 ? Colors.white : AppColors.textSecondary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: entry.rank <= 3 && icon != null
            ? Icon(
                icon,
                color: Colors.white,
                size: 24,
              )
            : Text(
                '${entry.rank}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: entry.rank <= 3 ? Colors.white : AppColors.textPrimary,
                ),
              ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.warning;
    return AppColors.error;
  }
}