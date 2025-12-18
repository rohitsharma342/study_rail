class StudyMaterialModel {
  final String id;
  final String title;
  final String subject;
  final String type; // video, document, test
  final String url;
  final String description;
  final int? duration; // for videos in seconds
  final int? size; // for documents in bytes
  final bool isPurchased;
  final String thumbnailUrl;

  StudyMaterialModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.url,
    required this.description,
    this.duration,
    this.size,
    this.isPurchased = false,
    required this.thumbnailUrl,
  });

  factory StudyMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudyMaterialModel(
      id: json['id'],
      title: json['title'],
      subject: json['subject'],
      type: json['type'],
      url: json['url'],
      description: json['description'],
      duration: json['duration'],
      size: json['size'],
      isPurchased: json['isPurchased'] ?? false,
      thumbnailUrl: json['thumbnailUrl'],
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
      'isPurchased': isPurchased,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedSize {
    if (size == null) return '';
    if (size! < 1024) return '${size}B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(1)}KB';
    return '${(size! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}