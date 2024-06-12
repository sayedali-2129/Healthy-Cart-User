import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
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
      final productData = pharmacyProvider.pharmacyCartProducts[index];
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
                          child: CustomCachedNetworkImage(
                            image: productData.productImage?.first ?? '',
                            fit: BoxFit.contain,
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 26),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Gap(12),
                            Text(
                              productData.productName ?? 'Unkown Name',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: 'by : ', // remeber to put space
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat',
                                        color: BColors.textBlack),
                                  ),
                                  TextSpan(
                                    text: productData.productName ??
                                        'Unkown Brand',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                        color: BColors.textBlack),
                                  ),
                                ])),
                            const Gap(4),
                            (productData.productDiscountRate == null)
                                ? RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.green),
                                      ),
                                      TextSpan(
                                        text:
                                            '${productData.productMRPRate ?? 'Unkown Price'}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.green),
                                      ),
                                    ]),
                                  )
                                : RichText(
                                    text: TextSpan(children: [
                                    const TextSpan(
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.green)),
                                    TextSpan(
                                      text:
                                          "${productData.productDiscountRate}",
                                      style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.green),
                                    ),
                                    const TextSpan(text: '  '),
                                    const TextSpan(
                                        text: "₹ ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.lineThrough,
                                            fontFamily: 'Montserrat',
                                            color: BColors.textBlack)),
                                    TextSpan(
                                      text: "${productData.productMRPRate}",
                                      style:const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.lineThrough,
                                            fontFamily: 'Montserrat',
                                            color: BColors.textBlack),
                                    ),
                                  ])),
                            const Gap(4),
                            
                            const Gap(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                QuantityCountWidget(
                                    incrementTap: () {
                                      pharmacyProvider.increment();
                                    },
                                    decrementTap: () {
                                      pharmacyProvider.decrement();
                                    },
                                    quantityValue: pharmacyProvider
                                        .productCartQuantityList[index]),

                                if (productData.productDiscountRate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: PercentageShowContainerWidget(
                                      text:
                                          '${productData.discountPercentage ?? '0'} % off',
                                      textColor: BColors.white,
                                      boxColor: BColors.offRed,
                                      width: 80,
                                      height: 32,
                                    ),
                                  ),
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
                  top: -1,
                  right: -1,
                  child: IconButton(
                      onPressed: () {
                        ConfirmAlertBoxWidget.showAlertConfirmBox(
                            context: context,
                            confirmButtonTap: () {},
                            titleText: 'Want to remove this product from cart',
                            subText: 'Are you sure you want to proceed ?');
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: BColors.red,
                      )))
            ],
          ),
        ),
      );
    });
  }
}
