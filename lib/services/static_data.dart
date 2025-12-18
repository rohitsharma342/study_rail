import '../models/user.dart';
import '../models/test.dart';
import '../models/question.dart';
import '../models/study_material.dart';

class StaticData {
  static User get currentUser => User(
    id: 'user001',
    name: 'Rajesh Kumar',
    email: 'rajesh.kumar@railway.gov.in',
    department: 'Operating',
    designation: 'Station Master',
    purchasedModules: ['fullLength', 'subject_gk', 'study_safety'],
    lastLogin: DateTime.now().subtract(Duration(hours: 2)),
  );

  static List<TestSeries> get testSeries => [
    TestSeries(
      id: 'test001',
      title: 'Station Master Promotion Test',
      description: 'Comprehensive test covering all aspects of station operations',
      type: 'fullLength',
      questionsCount: 120,
      duration: 180,
      price: 2999.0,
      discountedPrice: 1999.0,
      isPurchased: true,
      scheduledDate: DateTime.now().add(Duration(days: 3)),
      subjects: ['Operating Procedures', 'Safety Rules', 'Commercial Rules'],
      imageUrl: 'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=400',
    ),
    TestSeries(
      id: 'test002',
      title: 'Technical Officer Assessment',
      description: 'Technical knowledge test for engineering positions',
      type: 'subject',
      questionsCount: 80,
      duration: 120,
      price: 1999.0,
      discountedPrice: 1299.0,
      isPurchased: false,
      scheduledDate: DateTime.now().add(Duration(days: 7)),
      subjects: ['Technical Knowledge', 'Safety Rules'],
      imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400',
    ),
    TestSeries(
      id: 'test003',
      title: 'Quick Practice Tests',
      description: 'Short tests for daily practice',
      type: 'short',
      questionsCount: 30,
      duration: 45,
      price: 999.0,
      discountedPrice: 699.0,
      isPurchased: false,
      scheduledDate: DateTime.now().add(Duration(days: 1)),
      subjects: ['General Knowledge'],
      imageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
    ),
  ];

  static List<Question> get questions => [
    Question(
      id: 'q001',
      question: 'What is the maximum permissible speed for passenger trains on broad gauge?',
      options: ['110 kmph', '120 kmph', '130 kmph', '160 kmph'],
      correctAnswer: 3,
      explanation: 'The maximum permissible speed for passenger trains on broad gauge is 160 kmph as per Indian Railway standards.',
      subject: 'Operating Procedures',
      difficulty: 'Medium',
      tags: ['Speed', 'Broad Gauge', 'Passenger Trains'],
    ),
    Question(
      id: 'q002',
      question: 'Which signal indicates "Stop" in Indian Railways?',
      options: ['Green', 'Yellow', 'Red', 'Blue'],
      correctAnswer: 2,
      explanation: 'Red signal indicates "Stop" and trains must not pass this signal.',
      subject: 'Safety Rules',
      difficulty: 'Easy',
      tags: ['Signals', 'Safety', 'Operations'],
    ),
    Question(
      id: 'q003',
      question: 'What is the standard gauge used in Indian Railways?',
      options: ['1435 mm', '1676 mm', '1000 mm', '762 mm'],
      correctAnswer: 1,
      explanation: 'Indian Railways primarily uses broad gauge of 1676 mm (5 ft 6 in).',
      subject: 'Technical Knowledge',
      difficulty: 'Easy',
      tags: ['Gauge', 'Technical', 'Standards'],
    ),
  ];

  static List<StudyMaterial> get studyMaterials => [
    StudyMaterial(
      id: 'sm001',
      title: 'Railway Safety Rules - Complete Guide',
      subject: 'Safety Rules',
      type: 'video',
      url: 'https://example.com/video1',
      description: 'Comprehensive video covering all safety rules and procedures',
      duration: 120,
      size: 0,
      isPurchased: true,
      thumbnailUrl: 'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=400',
      uploadedDate: DateTime.now().subtract(Duration(days: 30)),
    ),
    StudyMaterial(
      id: 'sm002',
      title: 'Operating Procedures Manual',
      subject: 'Operating Procedures',
      type: 'document',
      url: 'https://example.com/doc1.pdf',
      description: 'Complete manual for station operations',
      duration: 0,
      size: 2048,
      isPurchased: true,
      thumbnailUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      uploadedDate: DateTime.now().subtract(Duration(days: 15)),
    ),
    StudyMaterial(
      id: 'sm003',
      title: 'Technical Knowledge Test Series',
      subject: 'Technical Knowledge',
      type: 'test',
      url: 'https://example.com/test1.pdf',
      description: 'Practice test papers for technical positions',
      duration: 0,
      size: 1024,
      isPurchased: false,
      thumbnailUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400',
      uploadedDate: DateTime.now().subtract(Duration(days: 7)),
    ),
  ];

  static Map<String, int> get notifications => {
    'New test available': 2,
    'Study material updated': 1,
    'Exam reminder': 1,
  };
}