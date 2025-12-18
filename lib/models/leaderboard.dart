class LeaderboardEntry {
  final String id;
  final String userId;
  final String userName;
  final String testId;
  final String testTitle;
  final int score;
  final int totalQuestions;
  final int rank;
  final Duration timeTaken;
  final DateTime completedAt;
  final String department;
  final String designation;

  LeaderboardEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.testId,
    required this.testTitle,
    required this.score,
    required this.totalQuestions,
    required this.rank,
    required this.timeTaken,
    required this.completedAt,
    required this.department,
    required this.designation,
  });

  double get percentage => (score / totalQuestions) * 100;

  String get formattedTime {
    final hours = timeTaken.inHours;
    final minutes = timeTaken.inMinutes.remainder(60);
    final seconds = timeTaken.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'testId': testId,
    'testTitle': testTitle,
    'score': score,
    'totalQuestions': totalQuestions,
    'rank': rank,
    'timeTaken': timeTaken.inSeconds,
    'completedAt': completedAt.toIso8601String(),
    'department': department,
    'designation': designation,
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) => LeaderboardEntry(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    testId: json['testId'],
    testTitle: json['testTitle'],
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    rank: json['rank'],
    timeTaken: Duration(seconds: json['timeTaken']),
    completedAt: DateTime.parse(json['completedAt']),
    department: json['department'],
    designation: json['designation'],
  );
}