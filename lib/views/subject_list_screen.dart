import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_controller.dart';
import '../controllers/subject_controller.dart';
import '../controllers/question_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/subject_card.dart';
import 'subject_questions_screen.dart';

class SubjectListScreen extends StatelessWidget {
  final ExamController examController = Get.put(ExamController());
  final SubjectController subjectController = Get.put(SubjectController());
  final QuestionController questionController = Get.put(QuestionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Question Bank',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _buildExamSelector(),
          Expanded(
            child: Obx(
              () => subjectController.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildSubjectsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Exam',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Obx(
            () => Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: examController.selectedExam?.id,
                  hint: Text('Choose an exam'),
                  isExpanded: true,
                  items: examController.exams.map((exam) {
                    return DropdownMenuItem<String>(
                      value: exam.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            exam.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            exam.code,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? examId) {
                    if (examId != null) {
                      final exam = examController.exams.firstWhere((e) => e.id == examId);
                      examController.selectExam(exam);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList() {
    return Obx(
      () {
        if (examController.selectedExam == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'Select an exam to view subjects',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (subjectController.subjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  'No subjects available',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: subjectController.subjects.length,
          itemBuilder: (context, index) {
            final subject = subjectController.subjects[index];
            return SubjectCard(
              subject: subject,
              onTap: () {
                subjectController.selectSubject(subject);
                Get.to(() => SubjectQuestionsScreen(subject: subject));
              },
            );
          },
        );
      },
    );
  }
}