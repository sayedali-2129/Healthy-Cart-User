import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class LabListCard extends StatelessWidget {
  const LabListCard({
    super.key,
    required this.screenwidth,
    required this.labortaryData,
    this.onTap,
  });
  final LabModel labortaryData;
  final void Function()? onTap;

  final double screenwidth;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      final labs = labortaryData;
      return GestureDetector(
        onTap: labs.isLabotaroryOn == false
            ? () {
                CustomToast.errorToast(
                    text: 'This Laboratory is not available now!');
              }
            : onTap,
        child: Stack(
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: screenwidth,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: BColors.white,
                  borderRadius: BorderRadius.circular(16),
                  
                ),
                child: Column(
                  children: [
                    Container(
                      height: 160,
                      width: screenwidth,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16))),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Positioned.fill(
                              child:
                                  CustomCachedNetworkImage(image: labs.image!)),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  BColors.black.withOpacity(0.5),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  labs.laboratoryName!.toUpperCase(),
                                  style: const TextStyle(
                                      color: BColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                             
                            ],
                          ),
                          const Gap(6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              const Gap(3),
                              Expanded(
                                child: Text(
                                  '${labs.address}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (labs.isLabotaroryOn == false)
              Container(
                height: 160,
                width: screenwidth,
                decoration: BoxDecoration(
                    color: BColors.white.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16))),
                child: Center(
                  child: Image.asset(
                    BImage.healthyCartLogoWithOpacity,
                    scale: 3,
                  ),
                ),
              ),
            if (labs.isLabotaroryOn == false)
              Positioned(
                  bottom: 40,
                  right: 8,
                  child: Image.asset(
                    BImage.currentlyUnavailable,
                    scale: 5,
                  ),),
          ],
        ),
      );
    });
  }
}
