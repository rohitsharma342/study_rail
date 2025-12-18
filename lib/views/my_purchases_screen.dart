import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/purchase_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/purchase_card.dart';

class MyPurchasesScreen extends StatelessWidget {
  final PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Purchases'),
      body: Obx(
        () => purchaseController.isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummarySection(),
                    SizedBox(height: 20),
                    _buildPurchasedTestsSection(),
                    SizedBox(height: 20),
                    _buildPurchasedMaterialsSection(),
                    SizedBox(height: 20),
                    _buildPurchaseHistorySection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSummarySection() {
    final summary = purchaseController.getPurchaseSummary();
    
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
          Text(
            'Purchase Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Test Series',
                  summary['totalTests'].toString(),
                  Icons.quiz,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Study Materials',
                  summary['totalMaterials'].toString(),
                  Icons.book,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '₹${summary['totalSpent'].toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasedTestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Purchased Test Series',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.liveTests),
              child: Text('View All Tests'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(
          () => purchaseController.purchasedTests.isEmpty
              ? _buildEmptySection(
                  'No test series purchased yet',
                  'Browse and purchase test series to start practicing',
                  Icons.quiz,
                  () => Get.toNamed(AppRoutes.liveTests),
                  'Browse Tests',
                )
              : Column(
                  children: purchaseController.purchasedTests
                      .map((test) => PurchaseCard(
                            title: test.title,
                            description: test.description,
                            imageUrl: test.imageUrl ?? '',
                            type: 'Test Series',
                            price: test.discountedPrice,
                            onAccess: () => Get.toNamed(AppRoutes.liveTests),
                          ))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildPurchasedMaterialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Purchased Study Materials',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.studyMaterial),
              child: Text('View All Materials'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(
          () => purchaseController.purchasedMaterials.isEmpty
              ? _buildEmptySection(
                  'No study materials purchased yet',
                  'Browse and purchase study materials for comprehensive preparation',
                  Icons.book,
                  () => Get.toNamed(AppRoutes.studyMaterial),
                  'Browse Materials',
                )
              : Column(
                  children: purchaseController.purchasedMaterials
                      .map((material) => PurchaseCard(
                            title: material.title,
                            description: material.description,
                            imageUrl: material.thumbnailUrl ?? '',
                            type: 'Study Material',
                            price: 0.0,
                            onAccess: () => Get.toNamed(AppRoutes.studyMaterial),
                          ))
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildPurchaseHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.history, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Text(
                      'Recent Purchases',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              ...purchaseController.getPurchaseHistory().take(5).map(
                (purchase) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: purchase['type'] == 'Test Series'
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      purchase['type'] == 'Test Series' ? Icons.quiz : Icons.book,
                      color: purchase['type'] == 'Test Series'
                          ? AppColors.primary
                          : AppColors.success,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    purchase['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    purchase['type'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (purchase['price'] > 0)
                        Text(
                          '₹${purchase['price'].toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      Text(
                        _formatDate(purchase['purchaseDate']),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
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
    );
  }

  Widget _buildEmptySection(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onAction,
    String actionText,
  ) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionText),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}