import '../models/user.dart';
import '../models/test.dart';
import '../models/question.dart';
import '../models/study_material.dart';
import '../models/exam.dart';
import '../models/subject.dart';

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
    Question(
      id: 'q004',
      question: 'What is the minimum age requirement for AEN (Assistant Executive Engineer) position?',
      options: ['21 years', '23 years', '25 years', '27 years'],
      correctAnswer: 0,
      explanation: 'The minimum age requirement for AEN position is 21 years as per railway recruitment rules.',
      subject: 'General Knowledge',
      difficulty: 'Easy',
      tags: ['Age', 'Recruitment', 'AEN'],
    ),
    Question(
      id: 'q005',
      question: 'Which department handles commercial activities in Indian Railways?',
      options: ['Operating Department', 'Commercial Department', 'Engineering Department', 'Electrical Department'],
      correctAnswer: 1,
      explanation: 'Commercial Department handles all commercial activities including ticketing, freight, and revenue management.',
      subject: 'Commercial Rules',
      difficulty: 'Easy',
      tags: ['Department', 'Commercial', 'Organization'],
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

  static List<Exam> get exams => [
    Exam(
      id: 'exam001',
      name: 'Assistant Executive Engineer',
      code: 'AEN',
      description: 'Technical examination for engineering positions in Indian Railways',
      subjects: ['Technical Knowledge', 'General Knowledge', 'Safety Rules'],
      totalQuestions: 150,
      duration: 180,
      level: 'Graduate',
    ),
    Exam(
      id: 'exam002',
      name: 'Assistant Finance Administrator',
      code: 'AFA',
      description: 'Financial and administrative examination for finance positions',
      subjects: ['Commercial Rules', 'General Knowledge', 'Operating Procedures'],
      totalQuestions: 120,
      duration: 150,
      level: 'Graduate',
    ),
    Exam(
      id: 'exam003',
      name: 'Assistant Mechanical Engineer',
      code: 'AME',
      description: 'Mechanical engineering examination for locomotive and workshop positions',
      subjects: ['Technical Knowledge', 'Safety Rules', 'Operating Procedures'],
      totalQuestions: 140,
      duration: 170,
      level: 'Graduate',
    ),
  ];

  static List<Subject> getSubjectsForExam(String examId) {
    switch (examId) {
      case 'exam001': // AEN
        return [
          Subject(
            id: 'sub001',
            name: 'Technical Knowledge',
            examId: examId,
            description: 'Engineering fundamentals, railway technology, and technical procedures',
            totalQuestions: 60,
            iconUrl: '',
            color: '#2196F3',
          ),
          Subject(
            id: 'sub002',
            name: 'General Knowledge',
            examId: examId,
            description: 'Current affairs, railway history, and general awareness',
            totalQuestions: 40,
            iconUrl: '',
            color: '#FF9800',
          ),
          Subject(
            id: 'sub003',
            name: 'Safety Rules',
            examId: examId,
            description: 'Railway safety protocols, emergency procedures, and regulations',
            totalQuestions: 50,
            iconUrl: '',
            color: '#F44336',
          ),
        ];
      case 'exam002': // AFA
        return [
          Subject(
            id: 'sub004',
            name: 'Commercial Rules',
            examId: examId,
            description: 'Financial procedures, commercial operations, and revenue management',
            totalQuestions: 50,
            iconUrl: '',
            color: '#4CAF50',
          ),
          Subject(
            id: 'sub005',
            name: 'General Knowledge',
            examId: examId,
            description: 'Current affairs, railway history, and general awareness',
            totalQuestions: 35,
            iconUrl: '',
            color: '#FF9800',
          ),
          Subject(
            id: 'sub006',
            name: 'Operating Procedures',
            examId: examId,
            description: 'Station operations, train operations, and administrative procedures',
            totalQuestions: 35,
            iconUrl: '',
            color: '#9C27B0',
          ),
        ];
      case 'exam003': // AME
        return [
          Subject(
            id: 'sub007',
            name: 'Technical Knowledge',
            examId: examId,
            description: 'Mechanical engineering, locomotive technology, and maintenance',
            totalQuestions: 70,
            iconUrl: '',
            color: '#2196F3',
          ),
          Subject(
            id: 'sub008',
            name: 'Safety Rules',
            examId: examId,
            description: 'Workshop safety, locomotive safety, and maintenance protocols',
            totalQuestions: 40,
            iconUrl: '',
            color: '#F44336',
          ),
          Subject(
            id: 'sub009',
            name: 'Operating Procedures',
            examId: examId,
            description: 'Locomotive operations, workshop procedures, and maintenance schedules',
            totalQuestions: 30,
            iconUrl: '',
            color: '#9C27B0',
          ),
        ];
      default:
        return [];
    }
  }

  static Map<String, int> get notifications => {
    'New test available': 2,
    'Study material updated': 1,
    'Exam reminder': 1,
  };
}