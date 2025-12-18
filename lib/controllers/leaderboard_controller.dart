import 'package:get/get.dart';
import '../models/leaderboard.dart';
import '../models/test_result.dart';
import '../services/static_data.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderboardEntry> _leaderboardEntries = <LeaderboardEntry>[].obs;
  final RxList<TestResult> _userResults = <TestResult>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedDate = ''.obs;
  final RxList<String> _availableDates = <String>[].obs;

  List<LeaderboardEntry> get leaderboardEntries => _leaderboardEntries;
  List<TestResult> get userResults => _userResults;
  bool get isLoading => _isLoading.value;
  String get selectedDate => _selectedDate.value;
  List<String> get availableDates => _availableDates;

  @override
  void onInit() {
    super.onInit();
    _loadStaticData();
    _loadAvailableDates();
    if (_availableDates.isNotEmpty) {
      _selectedDate.value = _availableDates.first;
      loadLeaderboardForDate(_selectedDate.value);
    }
  }

  void _loadStaticData() {
    _userResults.assignAll(StaticData.userTestResults.cast<TestResult>());
  }

  void _loadAvailableDates() {
    final dates = StaticData.leaderboardData.keys.toList();
    dates.sort((a, b) => b.compareTo(a));
    _availableDates.assignAll(dates);
  }

  Future<void> loadLeaderboardForDate(String date) async {
    try {
      _isLoading.value = true;
      _selectedDate.value = date;
      
      await Future.delayed(Duration(milliseconds: 500));
      
      final entries = StaticData.leaderboardData[date] ?? [];
      _leaderboardEntries.assignAll(entries.cast<LeaderboardEntry>());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load leaderboard data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshLeaderboard() async {
    if (_selectedDate.value.isNotEmpty) {
      await loadLeaderboardForDate(_selectedDate.value);
    }
  }

  List<TestResult> getUserResultsForDate(String date) {
    return _userResults.where((result) {
      final resultDate = result.completedAt.toIso8601String().split('T')[0];
      return resultDate == date;
    }).toList();
  }

  LeaderboardEntry? getUserRankForTest(String testId, String date) {
    final entries = StaticData.leaderboardData[date] ?? [];
    return entries.cast<LeaderboardEntry>().where((entry) => 
      entry.testId == testId && 
      entry.userId == StaticData.currentUser.id
    ).firstOrNull;
  }

  List<LeaderboardEntry> getTopPerformers({int limit = 10}) {
    final sortedEntries = List<LeaderboardEntry>.from(_leaderboardEntries);
    sortedEntries.sort((a, b) => a.rank.compareTo(b.rank));
    return sortedEntries.take(limit).toList();
  }

  Map<String, dynamic> getLeaderboardStats() {
    if (_leaderboardEntries.isEmpty) {
      return {
        'totalParticipants': 0,
        'averageScore': 0.0,
        'highestScore': 0,
        'lowestScore': 0,
      };
    }

    final scores = _leaderboardEntries.map((e) => e.score).toList();
    final totalScore = scores.reduce((a, b) => a + b);
    
    return {
      'totalParticipants': _leaderboardEntries.length,
      'averageScore': totalScore / _leaderboardEntries.length,
      'highestScore': scores.reduce((a, b) => a > b ? a : b),
      'lowestScore': scores.reduce((a, b) => a < b ? a : b),
    };
  }
}