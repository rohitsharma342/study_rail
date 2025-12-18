import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_app_bar.dart';

class MyPurchasesScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.myPurchases),
      body: Obx(() {
        final user = authController.user;
        if (user == null) {
          return _buildLoginPrompt();
        }
        
        final hasPurchases = user.purchasedTests.isNotEmpty || 
                           user.purchasedSubjects.isNotEmpty;
        
        if (!hasPurchases) {
          return _buildEmptyState();
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPurchaseSummary(user),
              SizedBox(height: AppSizes.paddingLarge),
              if (user.purchasedTests.isNotEmpty) ...[
                _buildPurchasedTests(user),
                SizedBox(height: AppSizes.paddingLarge),
              ],
              if (user.purchasedSubjects.isNotEmpty) ...[
                _buildPurchasedSubjects(user),
                SizedBox(height: AppSizes.paddingLarge),
              ],
              _buildQuickActions(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPurchaseSummary(user) {
    return Container(
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
            'Purchase Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Test Series',
                  user.purchasedTests.length.toString(),
                  Icons.quiz,
                ),
              ),
              SizedBox(width: AppSizes.paddingMedium),
              Expanded(
                child: _buildSummaryCard(
                  'Subject Access',
                  user.purchasedSubjects.length.toString(),
                  Icons.school,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasedTests(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Test Series',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.paddingMedium),
        ...user.purchasedTests.map((testId) => _buildTestCard(testId)).toList(),
      ],
    );
  }

  Widget _buildTestCard(String testId) {
    // Mock test data - in real app, you'd fetch from service
    final testData = {
      'test_001': {
        'title': 'Full Length Mock Test 1',
        'description': 'Complete railway departmental exam simulation',
        'validUntil': DateTime.now().add(Duration(days: 90)),
        'status': 'Active',
      },
    };
    
    final test = testData[testId];
    if (test == null) return SizedBox.shrink();
    
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.paddingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  child: Icon(
                    Icons.quiz,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSizes.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        test['description'] as String,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    test['status'] as String,
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4),
                Text(
                  'Valid until: ${_formatDate(test['validUntil'] as DateTime)}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.liveTests),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Access Test',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchasedSubjects(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject Access',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.paddingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.paddingMedium,
            mainAxisSpacing: AppSizes.paddingMedium,
            childAspectRatio: 1.2,
          ),
          itemCount: user.purchasedSubjects.length,
          itemBuilder: (context, index) {
            final subject = user.purchasedSubjects[index];
            return _buildSubjectCard(subject);
          },
        ),
      ],
    );
  }

  Widget _buildSubjectCard(String subject) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to subject-specific content
          Get.toNamed(AppRoutes.questionBank);
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Icon(
                  Icons.school,
                  color: AppColors.secondary,
                  size: 30,
                ),
              ),
              SizedBox(height: AppSizes.paddingSmall),
              Text(
                subject,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Full Access',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Browse Tests',
        'subtitle': 'Find more test series',
        'icon': Icons.search,
        'color': AppColors.primary,
        'route': AppRoutes.liveTests,
      },
      {
        'title': 'Study Materials',
        'subtitle': 'Access your content',
        'icon': Icons.library_books,
        'color': AppColors.secondary,
        'route': AppRoutes.studyMaterial,
      },
      {
        'title': 'Question Bank',
        'subtitle': 'Practice questions',
        'icon': Icons.quiz,
        'color': AppColors.success,
        'route': AppRoutes.questionBank,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.paddingMedium),
        ...actions.map((action) => _buildActionCard(action)).toList(),
      ],
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.paddingSmall),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: action['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Icon(
            action['icon'],
            color: action['color'],
          ),
        ),
        title: Text(
          action['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          action['subtitle'],
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: () => Get.toNamed(action['route']),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.paddingLarge),
          Text(
            'No Purchases Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Purchase test series or subject access to start your exam preparation journey.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSizes.paddingLarge),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.liveTests),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: Text('Browse Test Series'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.paddingLarge),
          Text(
            'Please Log In',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'Log in to view your purchases and access your content.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.paddingLarge),
          ElevatedButton(
            onPressed: () {
              // Navigate to login screen or show login dialog
              authController.login('user@studyrail.com', 'password');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: Text('Log In'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}