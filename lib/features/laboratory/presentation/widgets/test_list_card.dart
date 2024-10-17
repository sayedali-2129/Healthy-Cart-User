import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class TestListCard extends StatelessWidget {
  const TestListCard({
    super.key,
    required this.image,
    required this.testName,
    required this.testPrice,
    this.offerPrice,
    this.onAdd,
    required this.isSelected,
    required this.index,
    this.isDoorstepAvailable,
    this.doorstepList,
    this.labTestModel,
    this.doorStepTestModel,
  });

  final String image;
  final String testName;
  final num testPrice;
  final num? offerPrice;
  final bool isSelected;
  final void Function()? onAdd;
  final int index;
  final bool? isDoorstepAvailable;
  final bool? doorstepList;
  final LabTestModel? labTestModel;
  final LabTestModel? doorStepTestModel;
  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                height: 54,
                width: 54,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CustomCachedNetworkImage(image: image),
              ),
              const Gap(16),
              Expanded(
               
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                    Text(
                      testName,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const Gap(6),
                    offerPrice == null
                        ? RichText(
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
                                      fontFamily: 'Montserrat',
                                      color: BColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        : RichText(
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
                                      decoration:
                                          TextDecoration.lineThrough,
                                      fontFamily: 'Montserrat',
                                      color: BColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: offerPrice == 0
                                      ? '  Free'
                                      : '  ₹$offerPrice',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: BColors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),

                       doorstepList == true
                            ? const Gap(4)
                            : isDoorstepAvailable == true
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                      height: 23,
                                      width: 118,
                                      decoration: BoxDecoration(
                                          color: BColors.darkblue,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                          child: Text(
                                        'Door Step Available',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color: BColors.white,
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight.w600),
                                      )),
                                    ),
                                )
                                : const Gap(0),
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
                         color: !isSelected ? BColors.white : BColors.green,
                         border: Border.all(color: BColors.green),
                         borderRadius: BorderRadius.circular(6)),
                     child: Center(
                         child: !isSelected
                             ? const Icon(
                                 Icons.add,
                                 color: BColors.black,
                                 size: 20,
                               )
                             : const Icon(
                                 Icons.check,
                                 color: BColors.white,
                                 size: 18,
                               )),
                   ),
                 ),
               )
            ],
          ),
        ),
      );
    });
  }
}
