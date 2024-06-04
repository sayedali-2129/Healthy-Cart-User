import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class TestListCard extends StatelessWidget {
  const TestListCard({
    super.key,
    required this.image,
    required this.testName,
    required this.testPrice,
    required this.offerPrice,
    this.onAdd,
  });

  final String image;
  final String testName;
  final String testPrice;
  final String offerPrice;
  final void Function()? onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    height: 54,
                    width: 54,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CustomCachedNetworkImage(image: image),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const Gap(8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Test Fee - ',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: BColors.green,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                  text: '₹$testPrice',
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Montserrat',
                                      color: BColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: '  ₹$offerPrice',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: BColors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: onAdd,
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: BoxDecoration(
                      border: Border.all(color: BColors.green),
                      borderRadius: BorderRadius.circular(6)),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
