import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showNotification;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showNotification = false,
    this.notificationCount = 0,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [];
    
    if (showNotification) {
      appBarActions.add(
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: onNotificationTap ?? () {
                // Handle notification tap
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 99 ? '99+' : notificationCount.toString(),
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
      );
    }
    
    if (actions != null) {
      appBarActions.addAll(actions!);
    }

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: false,
      actions: appBarActions.isNotEmpty ? appBarActions : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}