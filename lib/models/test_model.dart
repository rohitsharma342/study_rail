class TestModel {
  final String id;
  final String title;
  final String description;
  final int duration;
  final int questionCount;
  final double price;
  final double discountedPrice;
  final String category;
  final bool isPurchased;
  final DateTime? scheduleDate;
  final String imageUrl;

  TestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.questionCount,
    required this.price,
    required this.discountedPrice,
    required this.category,
    this.isPurchased = false,
    this.scheduleDate,
    required this.imageUrl,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      questionCount: json['questionCount'],
      price: json['price'].toDouble(),
      discountedPrice: json['discountedPrice'].toDouble(),
      category: json['category'],
      isPurchased: json['isPurchased'] ?? false,
      scheduleDate: json['scheduleDate'] != null 
          ? DateTime.parse(json['scheduleDate']) 
          : null,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'questionCount': questionCount,
      'price': price,
      'discountedPrice': discountedPrice,
      'category': category,
      'isPurchased': isPurchased,
      'scheduleDate': scheduleDate?.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  double get savings => price - discountedPrice;
  double get discountPercentage => ((price - discountedPrice) / price) * 100;
}