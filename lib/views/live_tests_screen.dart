import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import '../controllers/test_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/question_widget.dart';

class LiveTestsScreen extends StatelessWidget {
  final TestController testController = Get.find<TestController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.liveTests),
      body: Obx(() => testController.isTestActive.value 
          ? _buildTestInterface()
          : _buildTestsList(),
      ),
    );
  }

  Widget _buildTestsList() {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: Obx(() => ListView.builder(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            itemCount: testController.filteredTests.length,
            itemBuilder: (context, index) {
              final test = testController.filteredTests[index];
              return _buildTestCard(test);
            },
          )),
        ),
        _buildPurchasePanel(),
      ],
    );
  }

  Widget _buildFilterSection() {
    final categories = ['All', 'Full Length', 'Short', 'Individual Subject', 'Miscellaneous'];
    
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Obx(() => Padding(
            padding: EdgeInsets.only(right: AppSizes.paddingSmall),
            child: FilterChip(
              label: Text(category),
              selected: testController.selectedFilter.value == category,
              onSelected: (selected) {
                testController.selectedFilter.value = category;
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            ),
          ));
        },
      ),
    );
  }

  Widget _buildTestCard(test) {
    final hasAccess = authController.user?.hasAccessToTest(test.id) ?? false;
    
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.paddingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusMedium),
            ),
            child: CachedNetworkImage(
              imageUrl: test.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.error),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        test.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (hasAccess)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'PURCHASED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  test.description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildTestInfo(Icons.schedule, '${test.duration} min'),
                    SizedBox(width: 16),
                    _buildTestInfo(Icons.quiz, '${test.questionCount} questions'),
                    SizedBox(width: 16),
                    _buildTestInfo(Icons.category, test.category),
                  ],
                ),
                if (test.scheduleDate != null) ...<Widget>[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Scheduled: ${_formatDateTime(test.scheduleDate!)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (test.discountedPrice < test.price) ...<Widget>[
                            Text(
                              '₹${test.price.toInt()}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹${test.discountedPrice.toInt()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.success,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${test.discountPercentage.toInt()}% OFF',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ] else ...<Widget>[
                            Text(
                              '₹${test.price.toInt()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() => Checkbox(
                          value: testController.selectedTests.contains(test),
                          onChanged: hasAccess ? null : (value) {
                            testController.toggleTestSelection(test);
                          },
                          activeColor: AppColors.primary,
                        )),
                        if (hasAccess)
                          ElevatedButton(
                            onPressed: () => testController.startTest(test),
                            child: Text(AppStrings.startTest),
                          )
                        else
                          Text(
                            'Select to purchase',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPurchasePanel() {
    return Obx(() {
      if (testController.selectedTests.isEmpty) {
        return SizedBox.shrink();
      }
      
      return Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Purchase Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Original Price:'),
                Text(
                  '₹${testController.totalOriginalPrice.toInt()}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discounted Price:'),
                Text(
                  '₹${testController.totalDiscountedPrice.toInt()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You Save:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                Text(
                  '₹${testController.totalSavings.toInt()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final success = await testController.purchaseSelectedTests();
                  if (success) {
                    Get.snackbar(
                      'Success',
                      'Tests purchased successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: Text('Purchase Selected Tests'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTestInterface() {
    return Column(
      children: [
        _buildTestHeader(),
        Expanded(
          child: Obx(() {
            final questions = testController.testQuestions;
            if (questions.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            
            final currentQuestion = questions[testController.currentQuestionIndex.value];
            return QuestionWidget(
              question: currentQuestion,
              onAnswerSelected: (index) => testController.selectAnswer(index),
              onMarkForReview: () => testController.markForReview(),
            );
          }),
        ),
        _buildTestNavigation(),
      ],
    );
  }

  Widget _buildTestHeader() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${testController.currentQuestionIndex.value + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'of ${testController.testQuestions.length}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  testController.formattedTimeRemaining,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildTestNavigation() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: testController.currentQuestionIndex.value > 0
                  ? () => testController.previousQuestion()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: Text(AppStrings.previous),
            ),
          ),
          SizedBox(width: AppSizes.paddingMedium),
          ElevatedButton(
            onPressed: () => _showQuestionPalette(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: Icon(Icons.grid_view),
          ),
          SizedBox(width: AppSizes.paddingMedium),
          Expanded(
            child: Obx(() => ElevatedButton(
              onPressed: testController.currentQuestionIndex.value < 
                      testController.testQuestions.length - 1
                  ? () => testController.nextQuestion()
                  : () => testController.submitTest(),
              child: Text(
                testController.currentQuestionIndex.value < 
                        testController.testQuestions.length - 1
                    ? AppStrings.next
                    : AppStrings.submit,
              ),
            )),
          ),
        ],
      ),
    );
  }

  void _showQuestionPalette() {
    Get.bottomSheet(
      Container(
        height: 300,
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLarge),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question Palette',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Expanded(
              child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: testController.testQuestions.length,
                itemBuilder: (context, index) {
                  final question = testController.testQuestions[index];
                  final isAnswered = question.isAnswered;
                  final isMarked = question.isMarkedForReview;
                  final isCurrent = index == testController.currentQuestionIndex.value;
                  
                  Color backgroundColor;
                  if (isCurrent) {
                    backgroundColor = AppColors.primary;
                  } else if (isAnswered && isMarked) {
                    backgroundColor = AppColors.warning;
                  } else if (isAnswered) {
                    backgroundColor = AppColors.success;
                  } else if (isMarked) {
                    backgroundColor = Colors.purple;
                  } else {
                    backgroundColor = Colors.grey[300]!;
                  }
                  
                  return GestureDetector(
                    onTap: () {
                      testController.jumpToQuestion(index);
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCurrent || isAnswered || isMarked 
                                ? Colors.white 
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Row(
              children: [
                _buildLegend(Colors.grey[300]!, 'Not Attempted'),
                SizedBox(width: 16),
                _buildLegend(AppColors.success, 'Answered'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildLegend(Colors.purple, 'Marked'),
                SizedBox(width: 16),
                _buildLegend(AppColors.warning, 'Answered & Marked'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Tomorrow ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}