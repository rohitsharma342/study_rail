import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/purchase_controller.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../services/static_data.dart';
import '../widgets/custom_app_bar.dart';

class StudyMaterialScreen extends StatefulWidget {
  @override
  _StudyMaterialScreenState createState() => _StudyMaterialScreenState();
}

class _StudyMaterialScreenState extends State<StudyMaterialScreen>
    with SingleTickerProviderStateMixin {
  final PurchaseController purchaseController = Get.find<PurchaseController>();
  late TabController _tabController;
  String selectedSubject = AppConstants.subjects.first;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Study Material'),
      body: Column(
        children: [
          _buildSubjectSelector(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVideosList(),
                _buildDocumentsList(),
                _buildTestsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector() {
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
            'Select Subject',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedSubject,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: AppConstants.subjects.map((subject) {
              return DropdownMenuItem(
                value: subject,
                child: Text(subject),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSubject = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        tabs: [
          Tab(
            icon: Icon(Icons.play_circle_outline),
            text: 'Videos',
          ),
          Tab(
            icon: Icon(Icons.description_outlined),
            text: 'Documents',
          ),
          Tab(
            icon: Icon(Icons.quiz_outlined),
            text: 'Tests',
          ),
        ],
      ),
    );
  }

  Widget _buildVideosList() {
    final videos = StaticData.studyMaterials
        .where((material) =>
            material.type == 'video' && material.subject == selectedSubject)
        .toList();

    if (videos.isEmpty) {
      return _buildEmptyState('No videos available for this subject');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildVideoCard(video);
      },
    );
  }

  Widget _buildDocumentsList() {
    final documents = StaticData.studyMaterials
        .where((material) =>
            material.type == 'document' && material.subject == selectedSubject)
        .toList();

    if (documents.isEmpty) {
      return _buildEmptyState('No documents available for this subject');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildTestsList() {
    final tests = StaticData.studyMaterials
        .where((material) =>
            material.type == 'test' && material.subject == selectedSubject)
        .toList();

    return Column(
      children: [
        if (tests.isNotEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _downloadAllTests();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.success,
                ),
                child: Text(
                  'Download All Tests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: tests.isEmpty
              ? _buildEmptyState('No test files available for this subject')
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return _buildTestCard(test);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(material) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: material.thumbnailUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 180,
                    color: AppColors.background,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    color: AppColors.background,
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    material.formattedDuration,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  material.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusChip(material.isPurchased),
                    ElevatedButton(
                      onPressed: material.isPurchased
                          ? () => _playVideo(material)
                          : () => _purchaseAccess(material),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: material.isPurchased
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                      child: Text(
                        material.isPurchased ? 'Play' : 'Purchase',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(material) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.picture_as_pdf,
            color: AppColors.error,
            size: 24,
          ),
        ),
        title: Text(
          material.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              material.description,
              style: TextStyle(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip(material.isPurchased),
                Spacer(),
                Text(
                  material.formattedSize,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: material.isPurchased
              ? () => _downloadDocument(material)
              : () => _purchaseAccess(material),
          style: ElevatedButton.styleFrom(
            backgroundColor: material.isPurchased
                ? AppColors.primary
                : AppColors.warning,
            minimumSize: Size(80, 36),
          ),
          child: Text(
            material.isPurchased ? 'Download' : 'Purchase',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(material) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.quiz,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          material.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              material.description,
              style: TextStyle(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip(material.isPurchased),
                Spacer(),
                Text(
                  material.formattedSize,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: material.isPurchased
              ? () => _downloadTest(material)
              : () => _purchaseAccess(material),
          style: ElevatedButton.styleFrom(
            backgroundColor: material.isPurchased
                ? AppColors.primary
                : AppColors.warning,
            minimumSize: Size(80, 36),
          ),
          child: Text(
            material.isPurchased ? 'Download' : 'Purchase',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isPurchased) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPurchased
            ? AppColors.success.withOpacity(0.1)
            : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isPurchased ? 'Purchased' : 'Premium',
        style: TextStyle(
          color: isPurchased ? AppColors.success : AppColors.warning,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _playVideo(material) {
    Get.snackbar(
      'Playing Video',
      'Opening ${material.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _downloadDocument(material) {
    Get.snackbar(
      'Download Started',
      'Downloading ${material.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _downloadTest(material) {
    Get.snackbar(
      'Download Started',
      'Downloading ${material.title}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _downloadAllTests() {
    Get.snackbar(
      'Download Started',
      'Downloading all test files for $selectedSubject',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _purchaseAccess(material) {
    Get.dialog(
      AlertDialog(
        title: Text('Purchase Required'),
        content: Text('You need to purchase access to view this ${material.type}.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              purchaseController.purchaseMaterial(material.id);
            },
            child: Text('Purchase'),
          ),
        ],
      ),
    );
  }
}