import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/app_colors.dart';

class PurchaseCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final double price;
  final VoidCallback onAccess;

  const PurchaseCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.price,
    required this.onAccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onAccess,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.background,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.background,
                    child: Icon(
                      Icons.image_not_supported,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getTypeColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              color: _getTypeColor(),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (price > 0) ..[
                          Spacer(),
                          Text(
                            '₹${price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type.toLowerCase()) {
      case 'test series':
        return AppColors.primary;
      case 'study material':
        return AppColors.success;
      default:
        return AppColors.secondary;
    }
  }
}