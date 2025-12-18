import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constants.dart';
import '../controllers/study_material_controller.dart';
import '../widgets/custom_app_bar.dart';

class StudyMaterialScreen extends StatelessWidget {
  final StudyMaterialController controller = Get.find<StudyMaterialController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: AppStrings.studyMaterial),
      body: Column(
        children: [
          _buildSubjectSelector(),
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(
            child: Obx(() => _buildMaterialsList()),
          ),
          if (controller.selectedTab.value == 'Tests') _buildDownloadAllButton(),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedSubject.value.isEmpty 
                ? null 
                : controller.selectedSubject.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
            items: controller.subjects.map((subject) {
              final hasAccess = controller.hasAccessToSubject(subject);
              return DropdownMenuItem<String>(
                value: subject,
                child: Row(
                  children: [
                    Text(
                      subject,
                      style: TextStyle(
                        color: hasAccess ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    if (!hasAccess) ...[
                      SizedBox(width: 8),
                      Icon(
                        Icons.lock,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectSubject(value);
              }
            },
            hint: Text('Choose a subject'),
          )),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search study materials...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
        onChanged: (value) {
          controller.updateSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Row(
        children: controller.availableTabs.map((tab) {
          final isSelected = controller.selectedTab.value == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTab(tab),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.paddingMedium,
                  horizontal: AppSizes.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget _buildMaterialsList() {
    final materials = controller.filteredMaterials;
    
    if (materials.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.paddingMedium),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return _buildMaterialCard(material);
      },
    );
  }

  Widget _buildMaterialCard(material) {
    final hasAccess = controller.hasAccessToMaterial(material);
    
    return Card(
      margin: EdgeInsets.only(bottom: AppSizes.paddingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (material.type == 'video') _buildVideoThumbnail(material),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getTypeIcon(material.type),
                      size: 20,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        material.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: hasAccess ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (!hasAccess)
                      Icon(
                        Icons.lock,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  material.description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    if (material.type == 'video' && material.duration != null) ...[
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        material.formattedDuration,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (material.size != null) ...[
                      if (material.type == 'video') SizedBox(width: 16),
                      Icon(
                        Icons.file_download,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        material.formattedSize,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    Spacer(),
                    _buildActionButton(material, hasAccess),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(material) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusMedium),
          ),
          child: CachedNetworkImage(
            imageUrl: material.thumbnailUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(Icons.error),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
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
    );
  }

  Widget _buildActionButton(material, bool hasAccess) {
    if (!hasAccess) {
      return ElevatedButton(
        onPressed: () => controller.showPurchaseDialog(material.subject),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Purchase',
          style: TextStyle(fontSize: 12),
        ),
      );
    }
    
    switch (material.type) {
      case 'video':
        return ElevatedButton.icon(
          onPressed: () => controller.playVideo(material),
          icon: Icon(Icons.play_arrow, size: 16),
          label: Text('Play', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
      case 'document':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => controller.viewDocument(material),
              icon: Icon(Icons.visibility, size: 16),
              label: Text('View', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => controller.downloadMaterial(material),
              icon: Icon(Icons.download, size: 16),
              label: Text('Download', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        );
      case 'test':
        return ElevatedButton.icon(
          onPressed: () => controller.downloadMaterial(material),
          icon: Icon(Icons.download, size: 16),
          label: Text('Download', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildDownloadAllButton() {
    return Obx(() {
      if (!controller.hasAccessToSubject(controller.selectedSubject.value)) {
        return SizedBox.shrink();
      }
      
      return Container(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => controller.downloadAllTests(),
            icon: Icon(Icons.cloud_download),
            label: Text('Download All Tests'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSizes.paddingMedium),
          Text(
            'No Study Materials Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Select a subject to view available materials',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_fill;
      case 'document':
        return Icons.description;
      case 'test':
        return Icons.quiz;
      default:
        return Icons.file_copy;
    }
  }
}