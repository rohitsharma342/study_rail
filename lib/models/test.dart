class TestSeries {
  final String id;
  final String title;
  final String description;
  final String type;
  final int questionsCount;
  final int duration; // in minutes
  final double price;
  final double discountedPrice;
  final bool isPurchased;
  final DateTime scheduledDate;
  final List<String> subjects;
  final String imageUrl;

  TestSeries({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.questionsCount,
    required this.duration,
    required this.price,
    required this.discountedPrice,
    required this.isPurchased,
    required this.scheduledDate,
    required this.subjects,
    required this.imageUrl,
  });

  double get savings => price - discountedPrice;
  double get discountPercentage => ((price - discountedPrice) / price) * 100;

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
      isPurchased: json['isPurchased'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      subjects: List<String>.from(json['subjects']),
      imageUrl: json['imageUrl'],
    );
  }
}