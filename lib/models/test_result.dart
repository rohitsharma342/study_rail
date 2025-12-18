class TestResult {
  final String id;
  final String userId;
  final String testId;
  final String testTitle;
  final int score;
  final int totalQuestions;
  final Duration timeTaken;
  final DateTime startedAt;
  final DateTime completedAt;
  final Map<String, int> subjectWiseScores;
  final List<String> correctAnswers;
  final List<String> incorrectAnswers;
  final List<String> skippedQuestions;
  final String status; // 'completed', 'abandoned', 'timeout'

  TestResult({
    required this.id,
    required this.userId,
    required this.testId,
    required this.testTitle,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.startedAt,
    required this.completedAt,
    required this.subjectWiseScores,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.skippedQuestions,
    required this.status,
  });

  double get percentage => (score / totalQuestions) * 100;
  
  int get attemptedQuestions => correctAnswers.length + incorrectAnswers.length;
  
  double get accuracy => attemptedQuestions > 0 ? (correctAnswers.length / attemptedQuestions) * 100 : 0;

  String get formattedTime {
    final hours = timeTaken.inHours;
    final minutes = timeTaken.inMinutes.remainder(60);
    final seconds = timeTaken.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'testId': testId,
    'testTitle': testTitle,
    'score': score,
    'totalQuestions': totalQuestions,
    'timeTaken': timeTaken.inSeconds,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt.toIso8601String(),
    'subjectWiseScores': subjectWiseScores,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
    'skippedQuestions': skippedQuestions,
    'status': status,
  };

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
    id: json['id'],
    userId: json['userId'],
    testId: json['testId'],
    testTitle: json['testTitle'],
    score: json['score'],
    totalQuestions: json['totalQuestions'],
    timeTaken: Duration(seconds: json['timeTaken']),
    startedAt: DateTime.parse(json['startedAt']),
    completedAt: DateTime.parse(json['completedAt']),
    subjectWiseScores: Map<String, int>.from(json['subjectWiseScores']),
    correctAnswers: List<String>.from(json['correctAnswers']),
    incorrectAnswers: List<String>.from(json['incorrectAnswers']),
    skippedQuestions: List<String>.from(json['skippedQuestions']),
    status: json['status'],
  );
}