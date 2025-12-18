class ExamConstants {
  static const int defaultExamDuration = 180; // 3 hours in minutes
  static const int shortExamDuration = 90; // 1.5 hours in minutes
  
  static const int questionsPerPage = 1;
  static const int autoSaveInterval = 30; // seconds
  
  static const String examInstructions = '''
IMPORTANT INSTRUCTIONS:

1. Total time for this examination is 3 hours.
2. The clock will be set at the server and the countdown timer will display the remaining time.
3. The Question Palette displayed on the right side of screen will show the status of each question using symbols.
4. You can navigate to any question by clicking on the question number in the Question Palette.
5. You can mark a question for review by clicking on "Mark for Review" button.
6. To change your answer, simply click on the new option.
7. To save your answer, you must click on "Save & Next" button.
8. To submit the examination, click on "Submit" button.

QUESTION STATUS:
• Not Visited (White) - You have not visited the question yet
• Not Answered (Red) - You have visited but not answered
• Answered (Green) - You have answered the question
• Marked for Review (Purple) - You have marked for review
• Answered & Marked (Purple with Green dot) - Answered and marked for review

All the best!''';

  static const Map<String, String> examWarnings = {
    'timeWarning': 'Only 15 minutes remaining!',
    'finalWarning': 'Only 5 minutes remaining!',
    'autoSubmit': 'Time is up! Exam will be auto-submitted.',
  };

  static const List<int> timeWarningMinutes = [15, 5, 1];
}