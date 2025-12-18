import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/test_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/test_card.dart';

class LiveTestsScreen extends StatelessWidget {
  final TestController testController = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Live Tests'),
      body: Obx(
        () => testController.isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    SizedBox(height: 20),
                    _buildTestSeriesList(),
                    SizedBox(height: 20),
                    _buildPurchaseSummary(),
                    SizedBox(height: 20),
                    _buildActiveTest(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderSection() {
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
            'Live Test Series',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Realistic CBT-style tests that mimic the actual exam environment',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('120 Questions', Icons.quiz),
              SizedBox(width: 12),
              _buildStatChip('180 Minutes', Icons.timer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestSeriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Test Series',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: testController.testSeries.length,
          itemBuilder: (context, index) {
            final test = testController.testSeries[index];
            return TestCard(
              test: test,
              isSelected: testController.selectedTests.contains(test.id),
              onSelectionChanged: (selected) {
                testController.toggleTestSelection(test.id);
              },
              onStartTest: () {
                testController.startTest(test.id);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPurchaseSummary() {
    return Obx(
      () => testController.selectedTests.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Purchase Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Original Price:',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        '₹${testController.totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discounted Price:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '₹${testController.totalDiscountedPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You Save:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        '₹${testController.totalSavings.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: testController.isLoading
                          ? null
                          : () {
                              testController.purchaseSelectedTests();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: testController.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Purchase Selected Tests',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildActiveTest() {
    return Obx(
      () => testController.isTestActive
          ? Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Test in Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          testController.getFormattedTime(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (testController.currentQuestionIndex + 1) / 120,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Question ${testController.currentQuestionIndex + 1} of 120',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            testController.endTest();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: Text('End Test'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}