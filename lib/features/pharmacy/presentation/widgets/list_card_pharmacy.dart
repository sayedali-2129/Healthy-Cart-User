import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';


class PharmacyListCard extends StatelessWidget {
  const PharmacyListCard({
    super.key,
    this.onTap,
    required this.index,
  });
  final void Function()? onTap;
  final int index;
  @override
  Widget build(BuildContext context) {

   
      return GestureDetector(
        // onTap: labProvider.labList[index].isLabotaroryOn == false
        //     ? () {
        //         CustomToast.sucessToast(
        //             text: 'This Laboratory is not available right now!');
        //       }
        //     : onTap,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            height: 104,
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
                           const CustomCachedNetworkImage(image: BImage.appBarImage),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Name',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: BColors.black),
                            ),
                            const Gap(5),
                            Text(
                              'No Adress',
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
             
          
                    ],
               ),   ),),
        ),);
  }
}
