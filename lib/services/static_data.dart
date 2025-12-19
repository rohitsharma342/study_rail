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
    purchasedModules: ['AEN', 'AEE'],
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
      name: 'Assistant Engineer (AEN)',
      code: 'AEN',
      description: 'Assistant Engineer Examination for Railway Recruitment',
      subjects: ['General Engineering', 'Technical Knowledge', 'General Awareness'],
      totalQuestions: 120,
      duration: 120,
      level: 'Graduate',
      iconUrl: 'https://example.com/aen.png',
      color: 0xFF2196F3,
    ),
    Exam(
      id: '2',
      name: 'Assistant Footplate Attendant (AFA)',
      code: 'AFA',
      description: 'Assistant Footplate Attendant Examination',
      subjects: ['General Knowledge', 'Technical Aptitude', 'Safety Procedures'],
      totalQuestions: 100,
      duration: 90,
      level: 'Intermediate',
      iconUrl: 'https://example.com/afa.png',
      color: 0xFF4CAF50,
    ),
    Exam(
      id: '3',
      name: 'Assistant Mechanical Engineer (AME)',
      code: 'AME',
      description: 'Assistant Mechanical Engineer Examination',
      subjects: ['Mechanical Engineering', 'General Aptitude', 'Technical Knowledge'],
      totalQuestions: 150,
      duration: 150,
      level: 'Graduate',
      iconUrl: 'https://example.com/ame.png',
      color: 0xFFFF9800,
    ),
    Exam(
      id: '4',
      name: 'Assistant Electrical Engineer (AEE)',
      code: 'AEE',
      description: 'Assistant Electrical Engineer Examination',
      subjects: ['Electrical Engineering', 'Power Systems', 'General Aptitude'],
      totalQuestions: 150,
      duration: 150,
      level: 'Graduate',
      iconUrl: 'https://example.com/aee.png',
      color: 0xFF9C27B0,
    ),
  ];

  static List<Subject> getSubjectsForExam(String examId) {
    switch (examId) {
      case '1': // AEN
        return [
          Subject(
            id: '1',
            name: 'General Engineering',
            examId: '1',
            description: 'General Engineering concepts for AEN',
            totalQuestions: 40,
            iconUrl: 'https://example.com/engineering.png',
            color: '0xFF2196F3',
          ),
          Subject(
            id: '2',
            name: 'Technical Knowledge',
            examId: '1',
            description: 'Technical Knowledge for AEN',
            totalQuestions: 40,
            iconUrl: 'https://example.com/technical.png',
            color: '0xFF4CAF50',
          ),
          Subject(
            id: '3',
            name: 'General Awareness',
            examId: '1',
            description: 'General Awareness for AEN',
            totalQuestions: 40,
            iconUrl: 'https://example.com/awareness.png',
            color: '0xFF8BC34A',
          ),
        ];
      case '2': // AFA
        return [
          Subject(
            id: '4',
            name: 'General Knowledge',
            examId: '2',
            description: 'General Knowledge for AFA',
            totalQuestions: 35,
            iconUrl: 'https://example.com/gk.png',
            color: '0xFF2196F3',
          ),
          Subject(
            id: '5',
            name: 'Technical Aptitude',
            examId: '2',
            description: 'Technical Aptitude for AFA',
            totalQuestions: 35,
            iconUrl: 'https://example.com/aptitude.png',
            color: '0xFF4CAF50',
          ),
          Subject(
            id: '6',
            name: 'Safety Procedures',
            examId: '2',
            description: 'Safety Procedures for AFA',
            totalQuestions: 30,
            iconUrl: 'https://example.com/safety.png',
            color: '0xFFFF9800',
          ),
        ];
      case '3': // AME
        return [
          Subject(
            id: '7',
            name: 'Mechanical Engineering',
            examId: '3',
            description: 'Mechanical Engineering for AME',
            totalQuestions: 60,
            iconUrl: 'https://example.com/mechanical.png',
            color: '0xFF2196F3',
          ),
          Subject(
            id: '8',
            name: 'General Aptitude',
            examId: '3',
            description: 'General Aptitude for AME',
            totalQuestions: 45,
            iconUrl: 'https://example.com/aptitude.png',
            color: '0xFF4CAF50',
          ),
          Subject(
            id: '9',
            name: 'Technical Knowledge',
            examId: '3',
            description: 'Technical Knowledge for AME',
            totalQuestions: 45,
            iconUrl: 'https://example.com/technical.png',
            color: '0xFFFF9800',
          ),
        ];
      case '4': // AEE
        return [
          Subject(
            id: '10',
            name: 'Electrical Engineering',
            examId: '4',
            description: 'Electrical Engineering for AEE',
            totalQuestions: 60,
            iconUrl: 'https://example.com/electrical.png',
            color: '0xFF2196F3',
          ),
          Subject(
            id: '11',
            name: 'Power Systems',
            examId: '4',
            description: 'Power Systems for AEE',
            totalQuestions: 45,
            iconUrl: 'https://example.com/power.png',
            color: '0xFF4CAF50',
          ),
          Subject(
            id: '12',
            name: 'General Aptitude',
            examId: '4',
            description: 'General Aptitude for AEE',
            totalQuestions: 45,
            iconUrl: 'https://example.com/aptitude.png',
            color: '0xFFFF9800',
          ),
        ];
      default:
        return [];
    }
  }

  static List<TestSeries> getTestSeriesForExam(String examId) {
    switch (examId) {
      case '1': // AEN
        return [
          TestSeries(
            id: '1',
            title: 'AEN Mock Test 1',
            description: 'Complete AEN mock test covering all subjects',
            type: 'Full Length',
            questionsCount: 120,
            duration: 120,
            price: 299.0,
            discountedPrice: 199.0,
            isPurchased: false,
            scheduledDate: DateTime.now().add(Duration(days: 2)),
            subjects: ['General Engineering', 'Technical Knowledge', 'General Awareness'],
            imageUrl: 'https://example.com/aen1.jpg',
          ),
          TestSeries(
            id: '2',
            title: 'AEN Subject Wise Test',
            description: 'AEN subject wise practice test',
            type: 'Subject Wise',
            questionsCount: 40,
            duration: 40,
            price: 149.0,
            discountedPrice: 99.0,
            isPurchased: true,
            scheduledDate: DateTime.now().add(Duration(days: 1)),
            subjects: ['General Engineering'],
            imageUrl: 'https://example.com/aen2.jpg',
          ),
        ];
      case '2': // AFA
        return [
          TestSeries(
            id: '3',
            title: 'AFA Mock Test 1',
            description: 'Complete AFA mock test',
            type: 'Full Length',
            questionsCount: 100,
            duration: 90,
            price: 199.0,
            discountedPrice: 149.0,
            isPurchased: false,
            scheduledDate: DateTime.now().add(Duration(days: 3)),
            subjects: ['General Knowledge', 'Technical Aptitude', 'Safety Procedures'],
            imageUrl: 'https://example.com/afa1.jpg',
          ),
        ];
      case '3': // AME
        return [
          TestSeries(
            id: '4',
            title: 'AME Mock Test 1',
            description: 'Complete AME mock test',
            type: 'Full Length',
            questionsCount: 150,
            duration: 150,
            price: 399.0,
            discountedPrice: 299.0,
            isPurchased: false,
            scheduledDate: DateTime.now().add(Duration(days: 4)),
            subjects: ['Mechanical Engineering', 'General Aptitude', 'Technical Knowledge'],
            imageUrl: 'https://example.com/ame1.jpg',
          ),
        ];
      case '4': // AEE
        return [
          TestSeries(
            id: '5',
            title: 'AEE Mock Test 1',
            description: 'Complete AEE mock test',
            type: 'Full Length',
            questionsCount: 150,
            duration: 150,
            price: 399.0,
            discountedPrice: 299.0,
            isPurchased: false,
            scheduledDate: DateTime.now().add(Duration(days: 5)),
            subjects: ['Electrical Engineering', 'Power Systems', 'General Aptitude'],
            imageUrl: 'https://example.com/aee1.jpg',
          ),
        ];
      default:
        return [];
    }
  }

  static List<TestSeries> testSeries = [
    TestSeries(
      id: '1',
      title: 'AEN Mock Test 1',
      description: 'Complete AEN mock test covering all subjects',
      type: 'Full Length',
      questionsCount: 120,
      duration: 120,
      price: 299.0,
      discountedPrice: 199.0,
      isPurchased: false,
      scheduledDate: DateTime.now().add(Duration(days: 2)),
      subjects: ['General Engineering', 'Technical Knowledge', 'General Awareness'],
      imageUrl: 'https://example.com/aen1.jpg',
    ),
    TestSeries(
      id: '2',
      title: 'AFA Mock Test 1',
      description: 'Complete AFA mock test',
      type: 'Full Length',
      questionsCount: 100,
      duration: 90,
      price: 199.0,
      discountedPrice: 149.0,
      isPurchased: true,
      scheduledDate: DateTime.now().add(Duration(days: 1)),
      subjects: ['General Knowledge', 'Technical Aptitude', 'Safety Procedures'],
      imageUrl: 'https://example.com/afa1.jpg',
    ),
    TestSeries(
      id: '3',
      title: 'AME Mock Test 1',
      description: 'Complete AME mock test',
      type: 'Full Length',
      questionsCount: 150,
      duration: 150,
      price: 399.0,
      discountedPrice: 299.0,
      isPurchased: false,
      scheduledDate: DateTime.now().add(Duration(days: 3)),
      subjects: ['Mechanical Engineering', 'General Aptitude', 'Technical Knowledge'],
      imageUrl: 'https://example.com/ame1.jpg',
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
      purchasedModules: ['AEN'],
      lastLogin: DateTime.now(),
      phone: '+91 9876543210',
      profileImage: 'https://example.com/profile1.jpg',
    ),
  ];

  static List<StudyMaterial> studyMaterials = [
    StudyMaterial(
      id: '1',
      title: 'AEN Engineering Formula Sheet',
      description: 'Complete engineering formulas for AEN exam',
      type: 'PDF',
      subject: 'General Engineering',
      url: 'https://example.com/aen_formulas.pdf',
      duration: 0,
      size: 2048,
      isPurchased: false,
      thumbnailUrl: 'https://example.com/aen_thumb.jpg',
      uploadedDate: DateTime.now(),
      price: 99.0,
      discountedPrice: 49.0,
      downloadUrl: 'https://example.com/aen_formulas.pdf',
    ),
    StudyMaterial(
      id: '2',
      title: 'Railway Safety Procedures',
      description: 'Comprehensive safety procedures study material',
      type: 'PDF',
      subject: 'Safety Procedures',
      url: 'https://example.com/safety.pdf',
      duration: 0,
      size: 3072,
      isPurchased: true,
      thumbnailUrl: 'https://example.com/safety_thumb.jpg',
      uploadedDate: DateTime.now(),
      price: 149.0,
      discountedPrice: 99.0,
      downloadUrl: 'https://example.com/safety.pdf',
    ),
  ];

  static List<TestResult> userTestResults = [
    TestResult(
      id: '1',
      userId: '1',
      testId: '1',
      testTitle: 'AEN Mock Test 1',
      score: 95,
      totalQuestions: 120,
      timeTaken: Duration(minutes: 110),
      startedAt: DateTime.now().subtract(Duration(days: 1, minutes: 110)),
      completedAt: DateTime.now().subtract(Duration(days: 1)),
      subjectWiseScores: {'General Engineering': 32, 'Technical Knowledge': 31, 'General Awareness': 32},
      correctAnswers: List.generate(95, (i) => i.toString()),
      incorrectAnswers: List.generate(25, (i) => (i + 95).toString()),
      skippedQuestions: [],
      status: 'completed',
    ),
    TestResult(
      id: '2',
      userId: '1',
      testId: '2',
      testTitle: 'AFA Mock Test 1',
      score: 78,
      totalQuestions: 100,
      timeTaken: Duration(minutes: 85),
      startedAt: DateTime.now().subtract(Duration(days: 2, minutes: 85)),
      completedAt: DateTime.now().subtract(Duration(days: 2)),
      subjectWiseScores: {'General Knowledge': 26, 'Technical Aptitude': 27, 'Safety Procedures': 25},
      correctAnswers: List.generate(78, (i) => i.toString()),
      incorrectAnswers: List.generate(22, (i) => (i + 78).toString()),
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
        testTitle: 'AEN Mock Test 1',
        score: 95,
        totalQuestions: 120,
        rank: 1,
        timeTaken: Duration(minutes: 110),
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
        testTitle: 'AEN Mock Test 1',
        score: 92,
        totalQuestions: 120,
        rank: 2,
        timeTaken: Duration(minutes: 115),
        completedAt: DateTime.now().subtract(Duration(days: 1)),
        department: 'Engineering',
        designation: 'Assistant Engineer',
        totalParticipants: 150,
      ),
    ],
  };
}