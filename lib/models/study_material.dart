class StudyMaterial {
  final String id;
  final String title;
  final String subject;
  final String type;
  final String url;
  final String description;
  final int duration;
  final int size;
  final double price;
  final bool isPurchased;
  final String thumbnailUrl;
  final String? downloadUrl;
  final DateTime uploadedDate;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.url,
    required this.description,
    this.duration = 0,
    this.size = 0,
    this.price = 0.0,
    this.isPurchased = false,
    required this.thumbnailUrl,
    this.downloadUrl,
    DateTime? uploadedDate,
  }) : uploadedDate = uploadedDate ?? DateTime.now();

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
      duration: json['duration'] ?? 0,
      size: json['size'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      isPurchased: json['isPurchased'] ?? false,
      thumbnailUrl: json['thumbnailUrl'],
      downloadUrl: json['downloadUrl'],
      uploadedDate: json['uploadedDate'] != null ? DateTime.parse(json['uploadedDate']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'type': type,
      'url': url,
      'description': description,
      'duration': duration,
      'size': size,
      'price': price,
      'isPurchased': isPurchased,
      'thumbnailUrl': thumbnailUrl,
      'downloadUrl': downloadUrl,
      'uploadedDate': uploadedDate.toIso8601String(),
    };
  }
}