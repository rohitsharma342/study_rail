import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotifications;
  final int notificationCount;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showNotifications = false,
    this.notificationCount = 0,
    this.actions,
    this.leading,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: [
        if (showNotifications)
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showNotifications();
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationCount > 9 ? '9+' : notificationCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        if (actions != null) ...actions!,
      ],
    );
  }

  void _showNotifications() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Close'),
                ),
              ],
            ),
            Divider(),
            _buildNotificationItem(
              'New test available',
              'Station Master Promotion Test is now available',
              Icons.quiz,
              AppColors.primary,
              DateTime.now().subtract(Duration(hours: 2)),
            ),
            _buildNotificationItem(
              'Study material updated',
              'Railway Safety Rules document has been updated',
              Icons.book,
              AppColors.success,
              DateTime.now().subtract(Duration(hours: 5)),
            ),
            _buildNotificationItem(
              'Exam reminder',
              'Your test is scheduled for tomorrow',
              Icons.schedule,
              AppColors.warning,
              DateTime.now().subtract(Duration(days: 1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    IconData icon,
    Color color,
    DateTime time,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(time),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}