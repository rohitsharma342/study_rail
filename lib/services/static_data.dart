import '../models/test.dart';
import '../models/question.dart';
import '../models/user.dart';
import '../models/study_material.dart';
import '../models/exam.dart';
import '../models/subject.dart';
import '../models/leaderboard.dart';
import '../models/test_result.dart';

class StaticData {
  static User currentUser = User(
    id: '1',
    name: 'John Doe',
    email: 'john@railway.gov.in',
    department: 'Engineering',
    designation: 'Assistant Engineer',
    purchasedModules: ['NEET', 'JEE'],
    lastLogin: DateTime.now(),
    phone: '+91 9876543210',
    profileImage: 'https://example.com/profile1.jpg',
  );

  static List<Question> questions = [
    Question(
      id: '1',
      question: 'What is the SI unit of electric current?',
      options: ['Volt', 'Ampere', 'Ohm', 'Watt'],
      correctAnswer: 1,
      explanation: 'The SI unit of electric current is Ampere (A), named after André-Marie Ampère.',
      subject: 'Physics',
      difficulty: 'Easy',
      tags: ['Current', 'SI Units', 'Electricity'],
    ),
    Question(
      id: '2',
      question: 'Which of the following is a noble gas?',
      options: ['Oxygen', 'Nitrogen', 'Helium', 'Hydrogen'],
      correctAnswer: 2,
      explanation: 'Helium is a noble gas with atomic number 2. Noble gases are chemically inert.',
      subject: 'Chemistry',
      difficulty: 'Easy',
      tags: ['Noble Gases', 'Periodic Table'],
    ),
    Question(
      id: '3',
      question: 'What is the powerhouse of the cell?',
      options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Endoplasmic Reticulum'],
      correctAnswer: 1,
      explanation: 'Mitochondria are called the powerhouse of the cell because they produce ATP.',
      subject: 'Biology',
      difficulty: 'Easy',
      tags: ['Cell Biology', 'Organelles'],
    ),
    Question(
      id: '4',
      question: 'What is the derivative of sin(x)?',
      options: ['cos(x)', '-cos(x)', 'tan(x)', '-sin(x)'],
      correctAnswer: 0,
      explanation: 'The derivative of sin(x) with respect to x is cos(x).',
      subject: 'Mathematics',
      difficulty: 'Medium',
      tags: ['Calculus', 'Derivatives', 'Trigonometry'],
    ),
    Question(
      id: '5',
      question: 'Which law states that energy cannot be created or destroyed?',
      options: ['Newton\'s First Law', 'Law of Conservation of Energy', 'Ohm\'s Law', 'Boyle\'s Law'],
      correctAnswer: 1,
      explanation: 'The Law of Conservation of Energy states that energy cannot be created or destroyed, only transformed.',
      subject: 'Physics',
      difficulty: 'Medium',
      tags: ['Energy', 'Conservation Laws'],
    ),
  ];

  static List<Exam> exams = [
    Exam(
      id: '1',
      name: 'NEET',
      code: 'NEET',
      description: 'National Eligibility cum Entrance Test',
      subjects: ['Physics', 'Chemistry', 'Biology'],
      totalQuestions: 180,
      duration: 180,
      level: 'Advanced',
      iconUrl: 'https://example.com/neet.png',
      color: 0xFF2196F3,
    ),
    Exam(
      id: '2',
      name: 'JEE Main',
      code: 'JEE',
      description: 'Joint Entrance Examination - Main',
      subjects: ['Physics', 'Chemistry', 'Mathematics'],
      totalQuestions: 90,
      duration: 180,
      level: 'Advanced',
      iconUrl: 'https://example.com/jee.png',
      color: 0xFF4CAF50,
    ),
  ];

  static List<Subject> getSubjectsForExam(String examId) {
    if (examId == '1') {
      return [
        Subject(
          id: '1',
          name: 'Physics',
          examId: '1',
          description: 'Physics subject for NEET',
          totalQuestions: 45,
          iconUrl: 'https://example.com/physics.png',
          color: '0xFF2196F3',
        ),
        Subject(
          id: '2',
          name: 'Chemistry',
          examId: '1',
          description: 'Chemistry subject for NEET',
          totalQuestions: 45,
          iconUrl: 'https://example.com/chemistry.png',
          color: '0xFF4CAF50',
        ),
        Subject(
          id: '3',
          name: 'Biology',
          examId: '1',
          description: 'Biology subject for NEET',
          totalQuestions: 90,
          iconUrl: 'https://example.com/biology.png',
          color: '0xFF8BC34A',
        ),
      ];
    } else {
      return [
        Subject(
          id: '4',
          name: 'Physics',
          examId: '2',
          description: 'Physics subject for JEE',
          totalQuestions: 30,
          iconUrl: 'https://example.com/physics.png',
          color: '0xFF2196F3',
        ),
        Subject(
          id: '5',
          name: 'Chemistry',
          examId: '2',
          description: 'Chemistry subject for JEE',
          totalQuestions: 30,
          iconUrl: 'https://example.com/chemistry.png',
          color: '0xFF4CAF50',
        ),
        Subject(
          id: '6',
          name: 'Mathematics',
          examId: '2',
          description: 'Mathematics subject for JEE',
          totalQuestions: 30,
          iconUrl: 'https://example.com/math.png',
          color: '0xFFFF9800',
        ),
      ];
    }
  }

  static List<TestSeries> testSeries = [
    TestSeries(
      id: '1',
      title: 'NEET Mock Test 1',
      description: 'Complete NEET mock test covering all subjects',
      type: 'Full Length',
      questionsCount: 180,
      duration: 180,
      price: 299.0,
      discountedPrice: 199.0,
      isPurchased: false,
      scheduledDate: DateTime.now().add(Duration(days: 2)),
      subjects: ['Physics', 'Chemistry', 'Biology'],
      imageUrl: 'https://example.com/neet1.jpg',
    ),
    TestSeries(
      id: '2',
      title: 'JEE Main Practice Test',
      description: 'JEE Main pattern test with detailed solutions',
      type: 'Subject Wise',
      questionsCount: 90,
      duration: 180,
      price: 199.0,
      discountedPrice: 149.0,
      isPurchased: true,
      scheduledDate: DateTime.now().add(Duration(days: 1)),
      subjects: ['Physics', 'Chemistry', 'Mathematics'],
      imageUrl: 'https://example.com/jee1.jpg',
    ),
    TestSeries(
      id: '3',
      title: 'AIIMS Mock Test Series',
      description: 'AIIMS entrance exam preparation test',
      type: 'Full Length',
      questionsCount: 120,
      duration: 90,
      price: 399.0,
      discountedPrice: 299.0,
      isPurchased: false,
      scheduledDate: DateTime.now().add(Duration(days: 3)),
      subjects: ['Physics', 'Chemistry', 'Biology', 'General Knowledge'],
      imageUrl: 'https://example.com/aiims1.jpg',
    ),
  ];

  static List<Question> getQuestionsForTest(String testId) {
    return questions;
  }

  static List<User> users = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      department: 'Engineering',
      designation: 'Assistant Engineer',
      purchasedModules: ['NEET'],
      lastLogin: DateTime.now(),
      phone: '+91 9876543210',
      profileImage: 'https://example.com/profile1.jpg',
    ),
  ];

  static List<StudyMaterial> studyMaterials = [
    StudyMaterial(
      id: '1',
      title: 'Physics Formula Sheet',
      description: 'Complete physics formulas for competitive exams',
      type: 'PDF',
      subject: 'Physics',
      url: 'https://example.com/physics.pdf',
      duration: 0,
      size: 2048,
      isPurchased: false,
      thumbnailUrl: 'https://example.com/physics_thumb.jpg',
      uploadedDate: DateTime.now(),
      price: 99.0,
      discountedPrice: 49.0,
      downloadUrl: 'https://example.com/physics.pdf',
    ),
    StudyMaterial(
      id: '2',
      title: 'Organic Chemistry Notes',
      description: 'Comprehensive organic chemistry study material',
      type: 'PDF',
      subject: 'Chemistry',
      url: 'https://example.com/chemistry.pdf',
      duration: 0,
      size: 3072,
      isPurchased: true,
      thumbnailUrl: 'https://example.com/chemistry_thumb.jpg',
      uploadedDate: DateTime.now(),
      price: 149.0,
      discountedPrice: 99.0,
      downloadUrl: 'https://example.com/chemistry.pdf',
    ),
  ];

  static List<TestResult> userTestResults = [
    TestResult(
      id: '1',
      userId: '1',
      testId: '1',
      testTitle: 'NEET Mock Test 1',
      score: 153,
      totalQuestions: 180,
      timeTaken: Duration(minutes: 160),
      startedAt: DateTime.now().subtract(Duration(days: 1, minutes: 160)),
      completedAt: DateTime.now().subtract(Duration(days: 1)),
      subjectWiseScores: {'Physics': 50, 'Chemistry': 48, 'Biology': 55},
      correctAnswers: List.generate(153, (i) => i.toString()),
      incorrectAnswers: List.generate(27, (i) => (i + 153).toString()),
      skippedQuestions: [],
      status: 'completed',
    ),
    TestResult(
      id: '2',
      userId: '1',
      testId: '2',
      testTitle: 'JEE Main Practice Test',
      score: 70,
      totalQuestions: 90,
      timeTaken: Duration(minutes: 165),
      startedAt: DateTime.now().subtract(Duration(days: 2, minutes: 165)),
      completedAt: DateTime.now().subtract(Duration(days: 2)),
      subjectWiseScores: {'Physics': 25, 'Chemistry': 22, 'Mathematics': 23},
      correctAnswers: List.generate(70, (i) => i.toString()),
      incorrectAnswers: List.generate(20, (i) => (i + 70).toString()),
      skippedQuestions: [],
      status: 'completed',
    ),
  ];

  static Map<String, List<LeaderboardEntry>> leaderboardData = {
    DateTime.now().toIso8601String().split('T')[0]: [
      LeaderboardEntry(
        id: '1',
        userId: '1',
        userName: 'John Doe',
        testId: '1',
        testTitle: 'NEET Mock Test 1',
        score: 153,
        totalQuestions: 180,
        rank: 1,
        timeTaken: Duration(minutes: 160),
        completedAt: DateTime.now().subtract(Duration(days: 1)),
        department: 'Engineering',
        designation: 'Assistant Engineer',
        totalParticipants: 150,
      ),
      LeaderboardEntry(
        id: '2',
        userId: '2',
        userName: 'Jane Smith',
        testId: '1',
        testTitle: 'NEET Mock Test 1',
        score: 148,
        totalQuestions: 180,
        rank: 2,
        timeTaken: Duration(minutes: 165),
        completedAt: DateTime.now().subtract(Duration(days: 1)),
        department: 'Medical',
        designation: 'Assistant Doctor',
        totalParticipants: 150,
      ),
    ],
  };
}