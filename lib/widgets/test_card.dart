import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/test.dart';
import '../utils/app_colors.dart';

class TestCard extends StatelessWidget {
  final TestSeries test;
  final bool isSelected;
  final Function(bool?) onSelectionChanged;
  final VoidCallback onStartTest;

  const TestCard({
    Key? key,
    required this.test,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onStartTest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: test.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 160,
                    color: AppColors.background,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 160,
                    color: AppColors.background,
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(test.type),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getTypeLabel(test.type),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (test.isPurchased)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Purchased',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (test.discountPercentage > 0)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${test.discountPercentage.toStringAsFixed(0)}% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  test.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(Icons.quiz, '${test.questionsCount} Questions'),
                    SizedBox(width: 8),
                    _buildInfoChip(Icons.timer, '${test.duration} min'),
                  ],
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: test.subjects.map((subject) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (test.price != test.discountedPrice)
                          Text(
                            '₹${test.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        Text(
                          '₹${test.discountedPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (!test.isPurchased)
                          Checkbox(
                            value: isSelected,
                            onChanged: onSelectionChanged,
                            activeColor: AppColors.primary,
                          ),
                        if (test.isPurchased)
                          ElevatedButton(
                            onPressed: onStartTest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                            child: Text('Start Test'),
                          ),
                      ],
                    ),
                  ],
                ),
                if (test.scheduledDate.isAfter(DateTime.now()))
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Scheduled: ${_formatDate(test.scheduledDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'fullLength':
        return AppColors.primary;
      case 'short':
        return AppColors.success;
      case 'subject':
        return AppColors.warning;
      case 'misc':
        return AppColors.secondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'fullLength':
        return 'FULL LENGTH';
      case 'short':
        return 'SHORT TEST';
      case 'subject':
        return 'SUBJECT-WISE';
      case 'misc':
        return 'MISCELLANEOUS';
      default:
        return 'TEST';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return 'in $difference days';
    }
  }
}