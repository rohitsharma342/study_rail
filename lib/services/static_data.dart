import '../models/test.dart';
import '../models/question.dart';
import '../models/user.dart';
import '../models/study_material.dart';

class StaticData {
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
    // Return sample questions based on test ID
    return [
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
  }

  static List<User> users = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
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
      price: 99.0,
      discountedPrice: 49.0,
      isPurchased: false,
      downloadUrl: 'https://example.com/physics.pdf',
      thumbnailUrl: 'https://example.com/physics_thumb.jpg',
    ),
    StudyMaterial(
      id: '2',
      title: 'Organic Chemistry Notes',
      description: 'Comprehensive organic chemistry study material',
      type: 'PDF',
      subject: 'Chemistry',
      price: 149.0,
      discountedPrice: 99.0,
      isPurchased: true,
      downloadUrl: 'https://example.com/chemistry.pdf',
      thumbnailUrl: 'https://example.com/chemistry_thumb.jpg',
    ),
  ];
}