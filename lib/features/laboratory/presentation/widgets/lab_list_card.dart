import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class LabListCard extends StatelessWidget {
  const LabListCard({
    super.key,
    required this.screenwidth,
    required this.index,
    this.onTap,
  });
  final int index;
  final void Function()? onTap;

  final double screenwidth;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      final labs = labProvider.labList[index];
      return GestureDetector(
        onTap: labs.isLabotaroryOn == false
            ? () {
                CustomToast.errorToast(
                    text: 'This Laboratory is not available now!');
              }
            : onTap,
        child: Stack(
          children: [
            Container(
              width: screenwidth,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: BColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: BColors.black.withOpacity(0.1),
                      blurRadius: 7,
                      spreadRadius: 5),
                ],
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
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
<<<<<<< HEAD
                          clipBehavior: Clip.antiAlias,
                          height: 52,
                          width: 52,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child:
                              CustomCachedNetworkImage(image: labList.image!),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labList.laboratoryName ?? 'No Name',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.black),
                              ),
                              const Gap(5),
                              Text(
                                labList.address ?? 'No Adress',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )
                            ],
=======
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                BColors.black.withOpacity(0.5),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
>>>>>>> ea14e3d792cc0f6f90cb22502fa8659c61c761b6
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
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: BColors.buttonGreen),
                              child: const Padding(
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Text(
                                      '4.54',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: BColors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
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
                                    fontSize: 13, fontWeight: FontWeight.w500),
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
            if (labs.isLabotaroryOn == false)
              Container(
                  height: 200,
                  width: screenwidth,
                  decoration: BoxDecoration(
                      color: BColors.white.withOpacity(0.6),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16))),
                  child: Image.asset(
                    BImage.currentlyUnavailable,
                    scale: 3,
                  )),
          ],
        ),
      );
    });
  }
}
