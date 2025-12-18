import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../controllers/auth_controller.dart';
import '../controllers/test_controller.dart';
import '../widgets/custom_app_bar.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TestController testController = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.dashboard,
        showNotification: true,
        notificationCount: 3,
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            SizedBox(height: AppSizes.paddingLarge),
            _buildSearchBar(),
            SizedBox(height: AppSizes.paddingLarge),
            _buildLiveTestsBanner(),
            SizedBox(height: AppSizes.paddingLarge),
            _buildQuickLinks(),
            SizedBox(height: AppSizes.paddingLarge),
            _buildMyPurchasesSummary(),
            SizedBox(height: AppSizes.paddingLarge),
            _buildFeaturedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  authController.user?.name ?? 'Guest User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  authController.user?.department ?? '',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            )),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: AppStrings.dashboard,
                  onTap: () {
                    Get.back();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.quiz,
                  title: AppStrings.liveTests,
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.liveTests);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.library_books,
                  title: AppStrings.questionBank,
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.questionBank);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.school,
                  title: AppStrings.studyMaterial,
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.studyMaterial);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_bag,
                  title: AppStrings.myPurchases,
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.myPurchases);
                  },
                ),
                Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    authController.logout();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildWelcomeCard() {
    return Obx(() => Container(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            authController.user?.name ?? 'Guest User',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ready to boost your exam preparation?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.search,
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
        onChanged: (value) {
          // Handle search
        },
      ),
    );
  }

  Widget _buildLiveTestsBanner() {
    return Obx(() {
      final upcomingTests = testController.tests
          .where((test) => test.scheduleDate != null && 
                 test.scheduleDate!.isAfter(DateTime.now()))
          .take(1)
          .toList();
      
      if (upcomingTests.isEmpty) {
        return SizedBox.shrink();
      }
      
      final test = upcomingTests.first;
      
      return GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.liveTests),
        child: Container(
          padding: EdgeInsets.all(AppSizes.paddingLarge),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              SizedBox(width: AppSizes.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Live Test',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      test.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Scheduled: ${_formatDate(test.scheduleDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
                size: 16,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildQuickLinks() {
    final quickLinks = [
      {
        'title': 'Live Tests',
        'subtitle': 'Start practicing',
        'icon': Icons.quiz,
        'color': AppColors.primary,
        'route': AppRoutes.liveTests,
      },
      {
        'title': 'Question Bank',
        'subtitle': 'Practice questions',
        'icon': Icons.library_books,
        'color': AppColors.success,
        'route': AppRoutes.questionBank,
      },
      {
        'title': 'Study Material',
        'subtitle': 'Videos & docs',
        'icon': Icons.school,
        'color': AppColors.warning,
        'route': AppRoutes.studyMaterial,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.paddingMedium),
        Row(
          children: quickLinks.map((link) => 
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: quickLinks.indexOf(link) < quickLinks.length - 1 
                      ? AppSizes.paddingSmall : 0,
                ),
                child: _buildQuickLinkCard(link),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickLinkCard(Map<String, dynamic> link) {
    return GestureDetector(
      onTap: () => Get.toNamed(link['route']),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: link['color'].withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: link['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Icon(
                link['icon'],
                color: link['color'],
                size: 24,
              ),
            ),
            SizedBox(height: AppSizes.paddingSmall),
            Text(
              link['title'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              link['subtitle'],
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPurchasesSummary() {
    return Obx(() => Container(
      padding: EdgeInsets.all(AppSizes.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Purchases',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.myPurchases),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Row(
            children: [
              _buildPurchaseStatCard(
                'Tests Purchased',
                authController.user?.purchasedTests.length.toString() ?? '0',
                Icons.quiz,
              ),
              SizedBox(width: AppSizes.paddingMedium),
              _buildPurchaseStatCard(
                'Subjects Access',
                authController.user?.purchasedSubjects.length.toString() ?? '0',
                Icons.book,
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildPurchaseStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: AppSizes.paddingSmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Content',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.paddingMedium),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              final items = [
                {
                  'title': 'Railway Exam Guide 2024',
                  'subtitle': 'Complete preparation guide',
                  'image': AppImages.railwayStudy,
                },
                {
                  'title': 'Mock Test Series',
                  'subtitle': '50+ practice tests',
                  'image': AppImages.examPrep,
                },
                {
                  'title': 'Study Materials',
                  'subtitle': 'Video lectures & notes',
                  'image': AppImages.books,
                },
              ];
              
              return Container(
                width: 140,
                margin: EdgeInsets.only(right: AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusMedium),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: items[index]['image']!,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppSizes.paddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[index]['title']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            items[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return 'In $difference days';
    }
  }
}