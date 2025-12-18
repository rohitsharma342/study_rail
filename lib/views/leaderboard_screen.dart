import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/leaderboard_card.dart';
import '../widgets/result_card.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardController controller = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Leaderboard & Results',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildLeaderboardTab(),
                        _buildMyResultsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text(
            'Select Date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Obx(() => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedDate.isEmpty ? null : controller.selectedDate,
                hint: Text('Select a date'),
                isExpanded: true,
                items: controller.availableDates.map((date) {
                  final dateTime = DateTime.parse(date);
                  final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                  return DropdownMenuItem<String>(
                    value: date,
                    child: Text(formattedDate),
                  );
                }).toList(),
                onChanged: (String? newDate) {
                  if (newDate != null) {
                    controller.loadLeaderboardForDate(newDate);
                  }
                },
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard, size: 18),
                SizedBox(width: 8),
                Text('Leaderboard'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assessment, size: 18),
                SizedBox(width: 8),
                Text('My Results'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    return Obx(() {
      if (controller.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      if (controller.leaderboardEntries.isEmpty) {
        return _buildEmptyState(
          icon: Icons.leaderboard_outlined,
          title: 'No Results Available',
          subtitle: 'No test results found for the selected date.',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshLeaderboard,
        color: AppColors.primary,
        child: Column(
          children: [
            _buildStatsCard(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.leaderboardEntries.length,
                itemBuilder: (context, index) {
                  final entry = controller.leaderboardEntries[index];
                  return LeaderboardCard(
                    entry: entry,
                    isCurrentUser: entry.userId == 'user001', // StaticData.currentUser.id
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMyResultsTab() {
    return Obx(() {
      final userResults = controller.getUserResultsForDate(controller.selectedDate);
      
      if (userResults.isEmpty) {
        return _buildEmptyState(
          icon: Icons.assessment_outlined,
          title: 'No Results Found',
          subtitle: 'You haven\'t taken any tests on the selected date.',
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: userResults.length,
        itemBuilder: (context, index) {
          final result = userResults[index];
          final userRank = controller.getUserRankForTest(result.testId, controller.selectedDate);
          return ResultCard(
            result: result,
            rank: userRank?.rank,
          );
        },
      );
    });
  }

  Widget _buildStatsCard() {
    return Obx(() {
      final stats = controller.getLeaderboardStats();
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Participants',
                    stats['totalParticipants'].toString(),
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Avg Score',
                    '${stats['averageScore'].toStringAsFixed(1)}%',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Highest',
                    '${stats['highestScore']}',
                    Icons.star,
                    AppColors.warning,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Lowest',
                    '${stats['lowestScore']}',
                    Icons.trending_down,
                    AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}