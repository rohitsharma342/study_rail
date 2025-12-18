import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_controller.dart';
import '../controllers/subject_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/exam_dropdown.dart';
import '../widgets/subject_card.dart';
import 'question_interface_screen.dart';

class SubjectListScreen extends StatelessWidget {
  final ExamController examController = Get.find<ExamController>();
  final SubjectController subjectController = Get.find<SubjectController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Question Bank'),
      body: Column(
        children: [
          _buildExamSelectionSection(),
          Expanded(child: _buildSubjectsList()),
        ],
      ),
    );
  }

  Widget _buildExamSelectionSection() {
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
            'Select Exam Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          ExamDropdown(),
          SizedBox(height: 8),
          Obx(
            () => examController.selectedExam != null
                ? Text(
                    examController.selectedExam!.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  )
                : SizedBox.shrink(),
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
                  'Select an exam type to view subjects',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        if (subjectController.isLoading) {
          return Center(child: CircularProgressIndicator());
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

        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.subject,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Subjects (${subjectController.subjects.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: subjectController.subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjectController.subjects[index];
                  return SubjectCard(
                    subject: subject,
                    onTap: () {
                      subjectController.selectSubject(subject);
                      Get.to(() => QuestionInterfaceScreen());
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}