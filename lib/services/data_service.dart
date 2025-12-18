import '../utils/constants.dart';

class DataService {
  Map<String, dynamic> getUserData() {
    return {
      'id': 'user_001',
      'name': 'Rajesh Kumar',
      'email': 'rajesh.kumar@railway.gov.in',
      'phone': '+91 9876543210',
      'department': 'Electrical',
      'purchasedTests': ['test_001'],
      'purchasedSubjects': ['General Knowledge'],
      'testScores': {
        'test_001': 85.5,
        'test_002': 78.0,
      },
    };
  }

  List<Map<String, dynamic>> getTestData() {
    return [
      {
        'id': 'test_001',
        'title': 'Full Length Mock Test 1',
        'description': 'Complete railway departmental exam simulation',
        'duration': 180,
        'questionCount': 150,
        'price': 299.0,
        'discountedPrice': 199.0,
        'category': 'Full Length',
        'scheduleDate': DateTime.now().add(Duration(days: 2)).toIso8601String(),
        'imageUrl': AppImages.examPrep,
      },
      {
        'id': 'test_002',
        'title': 'General Knowledge Test',
        'description': 'Current affairs and general knowledge for railway exams',
        'duration': 60,
        'questionCount': 50,
        'price': 149.0,
        'discountedPrice': 99.0,
        'category': 'Individual Subject',
        'scheduleDate': DateTime.now().add(Duration(days: 1)).toIso8601String(),
        'imageUrl': AppImages.books,
      },
      {
        'id': 'test_003',
        'title': 'Technical Knowledge Test',
        'description': 'Department specific technical questions',
        'duration': 90,
        'questionCount': 75,
        'price': 199.0,
        'discountedPrice': 149.0,
        'category': 'Individual Subject',
        'imageUrl': AppImages.railwayStudy,
      },
      {
        'id': 'test_004',
        'title': 'Short Practice Test',
        'description': 'Quick revision test for daily practice',
        'duration': 30,
        'questionCount': 25,
        'price': 99.0,
        'discountedPrice': 49.0,
        'category': 'Short',
        'imageUrl': AppImages.placeholder,
      },
    ];
  }

  List<Map<String, dynamic>> getTestQuestions(String testId) {
    return List.generate(25, (index) => {
      'id': 'q_${testId}_${index + 1}',
      'question': 'This is question ${index + 1} for test $testId. What is the correct answer?',
      'options': [
        'Option A - First choice',
        'Option B - Second choice', 
        'Option C - Third choice',
        'Option D - Fourth choice',
      ],
      'correctAnswer': index % 4,
      'subject': index % 3 == 0 ? 'General Knowledge' : 
                 index % 3 == 1 ? 'Technical Knowledge' : 'Reasoning',
      'explanation': 'This is the explanation for question ${index + 1}.',
      'difficulty': index % 3 == 0 ? 'Easy' : 
                   index % 3 == 1 ? 'Medium' : 'Hard',
    });
  }

  List<Map<String, dynamic>> getQuestionBankData() {
    final subjects = ['General Knowledge', 'Technical Knowledge', 'Reasoning', 'Mathematics'];
    
    return List.generate(100, (index) => {
      'id': 'qb_${index + 1}',
      'question': 'Question ${index + 1}: This is a sample question for practice. Choose the correct answer.',
      'options': [
        'Option A - Answer choice 1',
        'Option B - Answer choice 2',
        'Option C - Answer choice 3', 
        'Option D - Answer choice 4',
      ],
      'correctAnswer': index % 4,
      'subject': subjects[index % subjects.length],
      'explanation': 'Detailed explanation for question ${index + 1}.',
      'difficulty': index % 3 == 0 ? 'Easy' : 
                   index % 3 == 1 ? 'Medium' : 'Hard',
    });
  }

  List<String> getSubjects() {
    return [
      'General Knowledge',
      'Technical Knowledge', 
      'Reasoning',
      'Mathematics',
      'English',
      'Hindi',
    ];
  }

  List<Map<String, dynamic>> getStudyMaterialData() {
    final subjects = getSubjects();
    List<Map<String, dynamic>> materials = [];
    
    for (String subject in subjects) {
      // Add videos
      materials.addAll(List.generate(5, (index) => {
        'id': 'video_${subject}_${index + 1}',
        'title': '$subject Video Lecture ${index + 1}',
        'subject': subject,
        'type': 'video',
        'url': 'https://example.com/video',
        'description': 'Comprehensive video lecture covering $subject concepts.',
        'duration': (index + 1) * 600, // 10, 20, 30, 40, 50 minutes
        'isPurchased': subject == 'General Knowledge',
        'thumbnailUrl': AppImages.placeholder,
      }));
      
      // Add documents
      materials.addAll(List.generate(3, (index) => {
        'id': 'doc_${subject}_${index + 1}',
        'title': '$subject Study Notes ${index + 1}',
        'subject': subject,
        'type': 'document',
        'url': 'https://example.com/document.pdf',
        'description': 'Detailed study material for $subject.',
        'size': (index + 1) * 1024 * 1024, // 1MB, 2MB, 3MB
        'isPurchased': subject == 'General Knowledge',
        'thumbnailUrl': AppImages.books,
      }));
      
      // Add test files
      materials.addAll(List.generate(2, (index) => {
        'id': 'test_${subject}_${index + 1}',
        'title': '$subject Practice Test ${index + 1}',
        'subject': subject,
        'type': 'test',
        'url': 'https://example.com/test.pdf',
        'description': 'Downloadable practice test for $subject.',
        'size': 512 * 1024, // 512KB
        'isPurchased': subject == 'General Knowledge',
        'thumbnailUrl': AppImages.examPrep,
      }));
    }
    
    return materials;
  }

  List<Map<String, dynamic>> getUserPurchases() {
    return [
      {
        'id': 'purchase_001',
        'type': 'test',
        'title': 'Full Length Mock Test 1',
        'purchaseDate': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'amount': 199.0,
        'validUntil': DateTime.now().add(Duration(days: 90)).toIso8601String(),
      },
      {
        'id': 'purchase_002', 
        'type': 'subject',
        'title': 'General Knowledge - Complete Access',
        'purchaseDate': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        'amount': 299.0,
        'validUntil': DateTime.now().add(Duration(days: 180)).toIso8601String(),
      },
    ];
  }
}