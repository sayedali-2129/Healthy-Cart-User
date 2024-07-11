import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class CategoryListCard extends StatelessWidget {
  const CategoryListCard({
    super.key,
    required this.category,
  });

  final HospitalCategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: BColors.white,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CustomCachedNetworkImage(image: category.image ?? '')),
            ),
            const Gap(8),
            Expanded(
              child: Text(
                category.category ?? 'Unknown Category',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
