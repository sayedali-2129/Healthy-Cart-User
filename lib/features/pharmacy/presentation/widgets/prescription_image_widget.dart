import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/image_view/image_view.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';

class PrescriptionImageWidget extends StatelessWidget {
  const PrescriptionImageWidget({
    super.key,
    required this.pharmacyProvider, this.height = 120, this.width =100,
  });

  final PharmacyProvider pharmacyProvider;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height,
      height: width,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              EasyNavigation.push(
                context: context,
                type: PageTransitionType.rightToLeft,
                page: ImageView(
                  imageFile: pharmacyProvider.prescriptionImageFile!,
                ),
              );
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.file(
                pharmacyProvider.prescriptionImageFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: BColors.red,
              child: GestureDetector(
                onTap: () {
                  pharmacyProvider.clearImageFileAndPrescriptionDetails();
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: BColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
