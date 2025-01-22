import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class LabListCardHome extends StatelessWidget {
  const LabListCardHome({
    super.key,
    this.onTap,
    required this.index,
  });
  final void Function()? onTap;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      final labList = labProvider.labList[index];
      return GestureDetector(
        onTap: labProvider.labList[index].isLabotaroryOn == false
            ? () {
                CustomToast.errorToast(
                    text: 'This Laboratory is not available right now!');
              }
            : onTap,
        child: Stack(
          children: [
            Material(
              surfaceTintColor: BColors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: BColors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            height: 80,
                            width: 80,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child:
                                CustomCachedNetworkImage(image: labList.image!,),
                          ),
                          const Gap(12),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                             const Icon(
                            Icons.location_on,
                            size: 15,
                          ),
                                    Expanded(
                                      child: Text(
                                        labList.address ?? 'No Adress',
                                       
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(5),
                    ],
                  ),
                ),
              ),
            ),
            if (labProvider.labList[index].isLabotaroryOn == false)
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: BColors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16)),
              ),
              if (labProvider.labList[index].isLabotaroryOn == false)
                          Positioned(
                  top:8,
                  right:12,
                  child: Image.asset(BImage.healthyCartLogoWithOpacity, scale: 4,),
                ),   
           if (labProvider.labList[index].isLabotaroryOn == false)
            Positioned(
              bottom: 8,
              right: 8,
              child:  Image.asset(
                  BImage.currentlyUnavailable,
                  scale: 5,
                )),
          ],
        ),
      );
    });
  }
}
