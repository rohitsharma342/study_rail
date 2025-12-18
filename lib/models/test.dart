class Test {
  final String id;
  final String title;
  final String description;
  final String subject;
  final int duration;
  final int totalQuestions;
  final double price;
  final bool isPurchased;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? thumbnailUrl;

  Test({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.duration,
    required this.totalQuestions,
    required this.price,
    this.isPurchased = false,
    this.startTime,
    this.endTime,
    this.thumbnailUrl,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subject: json['subject'],
      duration: json['duration'],
      totalQuestions: json['totalQuestions'],
      price: json['price'].toDouble(),
      isPurchased: json['isPurchased'] ?? false,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'price': price,
      'isPurchased': isPurchased,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class TestSeries {
  final String id;
  final String title;
  final String description;
  final String type;
  final int questionsCount;
  final int duration;
  final double price;
  final double discountedPrice;
  final bool isPurchased;
  final DateTime? scheduledDate;
  final List<String> subjects;
  final String? imageUrl;

  TestSeries({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questionsCount,
    required this.duration,
    required this.price,
    required this.discountedPrice,
    this.isPurchased = false,
    this.scheduledDate,
    this.subjects = const [],
    this.imageUrl,
  });

  factory TestSeries.fromJson(Map<String, dynamic> json) {
    return TestSeries(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      questionsCount: json['questionsCount'],
      duration: json['duration'],
      price: json['price'].toDouble(),
      discountedPrice: json['discountedPrice'].toDouble(),
      isPurchased: json['isPurchased'] ?? false,
      scheduledDate: json['scheduledDate'] != null ? DateTime.parse(json['scheduledDate']) : null,
      subjects: json['subjects'] != null ? List<String>.from(json['subjects']) : [],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'questionsCount': questionsCount,
      'duration': duration,
      'price': price,
      'discountedPrice': discountedPrice,
      'isPurchased': isPurchased,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'subjects': subjects,
      'imageUrl': imageUrl,
    };
  }
}