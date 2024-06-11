import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_count_add.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Material(
          surfaceTintColor: BColors.white,
          color: BColors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 5,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 96,
                        width: 104,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: BColors.green,
                            ))),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(12),
                            Text(
                              'Name',
                              style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: 'by : ', // remeber to put space
                                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: BColors.textBlack),
                              ),
                              TextSpan(
                                text: 'product brand',
                                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: BColors.textBlack),
                              ),
    
                            ])),
                            const Gap(4),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: 'Product type : ', // remeber to put space
                                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: BColors.textBlack),
            
                              ),
                              TextSpan(
                                text: 'typeofprod',
                                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: BColors.textBlack),
                              ),
                            ])),
                            const Gap(4),
                            (true)
                                ? RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Our price : ',
                                        style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: BColors.textBlack),
                                      ),
                                      TextSpan(
                                          text: "₹ ",
                                          style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: BColors.green),),
                                      TextSpan(
                                        text:
                                            "25555 ",
                                        style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: BColors.green),
                                      ),
                                    ]),
                                  ): SizedBox(),
                                // : RichText(
                                //     text: TextSpan(children: [
                                //     TextSpan(
                                //       text: 'Our price : ',
                                //       style: TextStyle(
                    // fontSize: 12,
                    // fontWeight: FontWeight.w500,
                    // fontFamily: 'Montserrat',
                    // color: BColors.textBlack),
                                //     ),
                                //     TextSpan(
                                //         text: "₹ ",
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .labelLarge!
                                //             .copyWith(
                                //                 fontSize: 13,
                                //                 color: BColors.green,
                                //                 fontWeight: FontWeight.w700)),
                                //     TextSpan(
                                //       text:
                                //           "${pharmacyProvider.productList[index].productDiscountRate}",
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .labelLarge!
                                //           .copyWith(
                                //               color: BColors.green,
                                //               fontSize: 13,
                                //               fontWeight: FontWeight.w700),
                                //     ),
                                //     const TextSpan(text: '  '),
                                //     TextSpan(
                                //       text:
                                //           "${pharmacyProvider.productList[index].productMRPRate}",
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .labelLarge!
                                //           .copyWith(
                                //               fontSize: 12,
                                //               decoration:
                                //                   TextDecoration.lineThrough,
                                //               decorationThickness: 2.0,
                                //               fontWeight: FontWeight.w700),
                                //     ),
                                //   ])),
                            const Gap(8),
                            // if (pharmacyProvider
                            //         .productList[index].productDiscountRate !=
                            //     null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                PercentageShowContainerWidget(
                                  text: '25 % off',
                                  textColor: BColors.white,
                                  boxColor: BColors.offRed,
                                  width: 80,
                                  height: 32,
                                ),
                                QuantityCountWidget()
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(onPressed: (){}, icon: Icon(Icons.remove_circle_outline, color: BColors.red,)))
            ],
          ),
        ),
      );
    }
    
    );
  }
}
