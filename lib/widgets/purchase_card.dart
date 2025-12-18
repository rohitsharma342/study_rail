import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PurchaseCard extends StatelessWidget {
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final VoidCallback onPurchase;
  final bool isSelected;
  final VoidCallback? onSelectionChanged;

  const PurchaseCard({
    Key? key,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.onPurchase,
    this.isSelected = false,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savings = originalPrice - discountedPrice;
    final discountPercentage = ((originalPrice - discountedPrice) / originalPrice) * 100;

    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (onSelectionChanged != null)
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onSelectionChanged?.call(),
                    activeColor: AppColors.primary,
                  ),
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
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (discountedPrice < originalPrice) ..[
                        Text(
                          '₹${originalPrice.toInt()}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${discountedPrice.toInt()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.success,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${discountPercentage.toInt()}% OFF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Save ₹${savings.toInt()}',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else [
                        Text(
                          '₹${originalPrice.toInt()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onSelectionChanged == null)
                  ElevatedButton(
                    onPressed: onPurchase,
                    child: Text('Purchase'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}