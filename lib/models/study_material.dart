class StudyMaterial {
  final String id;
  final String title;
  final String subject;
  final String type;
  final String url;
  final String description;
  final int duration;
  final int size;
  final bool isPurchased;
  final String thumbnailUrl;
  final DateTime uploadedDate;
  final double? price;
  final double? discountedPrice;
  final String? downloadUrl;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.url,
    required this.description,
    required this.duration,
    required this.size,
    required this.isPurchased,
    required this.thumbnailUrl,
    required this.uploadedDate,
    this.price,
    this.discountedPrice,
    this.downloadUrl,
  });

  String get formattedSize {
    if (size < 1024) {
      return '${size}KB';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)}MB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  String get formattedDuration {
    int hours = duration ~/ 60;
    int minutes = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      type: json['type'],
      url: json['url'],
      description: json['description'],
      duration: json['duration'],
      size: json['size'],
      isPurchased: json['isPurchased'],
      thumbnailUrl: json['thumbnailUrl'],
      uploadedDate: DateTime.parse(json['uploadedDate']),
      price: json['price']?.toDouble(),
      discountedPrice: json['discountedPrice']?.toDouble(),
      downloadUrl: json['downloadUrl'],
    );
  }
}