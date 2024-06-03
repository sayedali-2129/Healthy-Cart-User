import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class LabListCard extends StatelessWidget {
  const LabListCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  height: 46,
                  width: 46,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.amber),
                ),
                const Gap(8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Neethi Laboratory',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: BColors.black),
                      ),
                      Gap(5),
                      Text(
                        '2972 Westheimer Rd. Santa Ana, Illinois 85486xm',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Gap(5),
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
          ],
        ),
      ),
    );
  }
}
