import '../models/user.dart';
import '../models/test.dart';
import '../models/question.dart';
import '../models/study_material.dart';
import '../models/exam.dart';

class StaticData {
  static final List<User> users = [
    User(
      id: '1',
      name: 'Rajesh Kumar',
      email: 'rajesh.kumar@railway.gov.in',
      designation: 'Station Master',
      department: 'Operations',
      employeeId: 'SM001',
    ),
    User(
      id: '2',
      name: 'Priya Sharma',
      email: 'priya.sharma@railway.gov.in',
      designation: 'Assistant Station Master',
      department: 'Operations',
      employeeId: 'ASM002',
    ),
  ];

  static final List<Test> tests = [
    Test(
      id: '1',
      title: 'Station Master Promotion Test',
      description: 'Comprehensive test for Station Master promotion covering all railway operations',
      subject: 'Railway Operations',
      duration: 180,
      totalQuestions: 100,
      price: 299.0,
      isPurchased: true,
      startTime: DateTime.now().add(Duration(days: 3)),
      endTime: DateTime.now().add(Duration(days: 4)),
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Station+Master+Test',
    ),
    Test(
      id: '2',
      title: 'Signal & Telecommunication Test',
      description: 'Technical test for S&T department covering signaling systems',
      subject: 'Signal & Telecommunication',
      duration: 120,
      totalQuestions: 75,
      price: 199.0,
      isPurchased: false,
      startTime: DateTime.now().add(Duration(days: 7)),
      endTime: DateTime.now().add(Duration(days: 8)),
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=S%26T+Test',
    ),
    Test(
      id: '3',
      title: 'Loco Pilot Aptitude Test',
      description: 'Aptitude and technical test for Locomotive Pilot recruitment',
      subject: 'Locomotive Operations',
      duration: 150,
      totalQuestions: 90,
      price: 249.0,
      isPurchased: true,
      startTime: DateTime.now().add(Duration(days: 5)),
      endTime: DateTime.now().add(Duration(days: 6)),
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Loco+Pilot+Test',
    ),
  ];

  static final List<Question> questions = [
    Question(
      id: '1',
      questionText: 'What is the maximum speed limit for passenger trains on broad gauge main line?',
      options: ['110 kmph', '130 kmph', '160 kmph', '200 kmph'],
      correctAnswer: '130 kmph',
      subject: 'Railway Operations',
      difficulty: 'Medium',
      explanation: 'The maximum speed limit for passenger trains on broad gauge main line is 130 kmph as per Indian Railway standards.',
    ),
    Question(
      id: '2',
      questionText: 'Which signal indicates "Proceed with caution"?',
      options: ['Green', 'Yellow', 'Red', 'Double Yellow'],
      correctAnswer: 'Yellow',
      subject: 'Signal & Telecommunication',
      difficulty: 'Easy',
      explanation: 'Yellow signal indicates "Proceed with caution" and the driver should be prepared to stop at the next signal.',
    ),
    Question(
      id: '3',
      questionText: 'What is the standard gauge measurement in Indian Railways?',
      options: ['1435 mm', '1676 mm', '1000 mm', '762 mm'],
      correctAnswer: '1676 mm',
      subject: 'Railway Operations',
      difficulty: 'Easy',
      explanation: 'The broad gauge (standard gauge) in Indian Railways is 1676 mm (5 ft 6 in).',
    ),
    Question(
      id: '4',
      questionText: 'Which type of brake system is commonly used in modern trains?',
      options: ['Vacuum brake', 'Air brake', 'Hand brake', 'Electric brake'],
      correctAnswer: 'Air brake',
      subject: 'Locomotive Operations',
      difficulty: 'Medium',
      explanation: 'Air brake system is the most commonly used braking system in modern trains due to its efficiency and reliability.',
    ),
    Question(
      id: '5',
      questionText: 'What does the term "Block Section" mean in railway operations?',
      options: [
        'A section where trains are blocked',
        'A section of track between two stations',
        'A section that can accommodate only one train at a time',
        'A section under maintenance'
      ],
      correctAnswer: 'A section that can accommodate only one train at a time',
      subject: 'Railway Operations',
      difficulty: 'Medium',
      explanation: 'A Block Section is a section of railway track that can accommodate only one train at a time for safety reasons.',
    ),
    Question(
      id: '6',
      questionText: 'What is the purpose of a Distant signal?',
      options: [
        'To control entry into a station',
        'To give advance warning of the Home signal',
        'To indicate platform number',
        'To show train speed'
      ],
      correctAnswer: 'To give advance warning of the Home signal',
      subject: 'Signal & Telecommunication',
      difficulty: 'Medium',
      explanation: 'Distant signal gives advance warning to the driver about the aspect of the Home signal ahead.',
    ),
  ];

  static final List<StudyMaterial> studyMaterials = [
    StudyMaterial(
      id: '1',
      title: 'Railway Operations Manual',
      description: 'Comprehensive guide covering all aspects of railway operations',
      subject: 'Railway Operations',
      type: 'PDF',
      price: 99.0,
      isPurchased: true,
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Operations+Manual',
      downloadUrl: 'https://example.com/railway-operations-manual.pdf',
    ),
    StudyMaterial(
      id: '2',
      title: 'Signal Engineering Handbook',
      description: 'Technical handbook for signal and telecommunication systems',
      subject: 'Signal & Telecommunication',
      type: 'PDF',
      price: 149.0,
      isPurchased: false,
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Signal+Handbook',
      downloadUrl: 'https://example.com/signal-handbook.pdf',
    ),
    StudyMaterial(
      id: '3',
      title: 'Locomotive Maintenance Guide',
      description: 'Complete guide for locomotive maintenance and operations',
      subject: 'Locomotive Operations',
      type: 'Video',
      price: 199.0,
      isPurchased: true,
      thumbnailUrl: 'https://via.placeholder.com/300x200?text=Loco+Maintenance',
      downloadUrl: 'https://example.com/loco-maintenance-video.mp4',
    ),
  ];

  static final List<Exam> exams = [
    Exam(
      id: '1',
      name: 'Railway Recruitment Board - NTPC',
      code: 'RRB-NTPC-2024',
      description: 'Non-Technical Popular Categories examination for various posts in Indian Railways including Station Master, Goods Guard, Commercial Apprentice, etc.',
      subjects: ['General Awareness', 'Mathematics', 'General Intelligence & Reasoning'],
      totalQuestions: 100,
      duration: 90,
      level: 'Intermediate',
    ),
    Exam(
      id: '2',
      name: 'Railway Recruitment Board - Group D',
      code: 'RRB-GROUP-D-2024',
      description: 'Group D examination for Track Maintainer, Helper, Assistant Pointsman, Level-1 posts in Indian Railways.',
      subjects: ['General Science', 'Mathematics', 'General Intelligence & Reasoning', 'General Awareness'],
      totalQuestions: 100,
      duration: 90,
      level: 'Beginner',
    ),
    Exam(
      id: '3',
      name: 'Assistant Loco Pilot',
      code: 'RRB-ALP-2024',
      description: 'Assistant Locomotive Pilot examination covering technical and aptitude sections for locomotive operations.',
      subjects: ['Mathematics', 'General Intelligence & Reasoning', 'Basic Science & Engineering', 'General Awareness'],
      totalQuestions: 75,
      duration: 60,
      level: 'Advanced',
    ),
    Exam(
      id: '4',
      name: 'Station Master Promotion',
      code: 'SM-PROMO-2024',
      description: 'Departmental promotion examination for Station Master post covering railway operations, rules, and procedures.',
      subjects: ['Railway Operations', 'General & Subsidiary Rules', 'Commercial Rules', 'Safety Rules'],
      totalQuestions: 150,
      duration: 180,
      level: 'Advanced',
    ),
    Exam(
      id: '5',
      name: 'Junior Engineer - Signal',
      code: 'JE-SIGNAL-2024',
      description: 'Junior Engineer examination for Signal & Telecommunication department covering technical subjects.',
      subjects: ['Electronics', 'Telecommunication', 'Signal Engineering', 'General Awareness'],
      totalQuestions: 120,
      duration: 120,
      level: 'Advanced',
    ),
  ];
}