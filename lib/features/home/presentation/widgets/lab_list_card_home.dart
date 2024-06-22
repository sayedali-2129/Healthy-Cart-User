import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
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
                CustomToast.sucessToast(
                    text: 'This Laboratory is not available right now!');
              }
            : onTap,
        child: Stack(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                    color: BColors.black.withOpacity(0.3))
              ], border: Border.all(), borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
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
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),
                    /* ----------------------------- AVAILABLE TESTS ---------------------------- */
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: BColors.mainlightColor,
                                ),
                                const Gap(5),
                                Expanded(
                                  child: Text(
                                    'Blood Test',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: BColors.black.withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: BColors.mainlightColor,
                                ),
                                const Gap(5),
                                Expanded(
                                  child: Text(
                                    'Blood Test',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: BColors.black.withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: BColors.mainlightColor,
                                ),
                                const Gap(5),
                                Expanded(
                                  child: Text(
                                    'Blood Test',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: BColors.black.withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* -------------------------------------------------------------------------- */
                  ],
                ),
              ),
            ),
            if (labProvider.labList[index].isLabotaroryOn == false)
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: BColors.white.withOpacity(0.7),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(16)),
                child: const Center(
                    // child: Text(
                    //   'This Laboratory is not available right now!',
                    //   style: TextStyle(
                    //       color: BColors.black, fontWeight: FontWeight.w600),
                    // ),
                    ),
              )
          ],
        ),
      );
    });
  }
}
