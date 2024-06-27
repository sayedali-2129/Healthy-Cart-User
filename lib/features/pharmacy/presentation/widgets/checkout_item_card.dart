import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:provider/provider.dart';

class CheckOutItemsCard extends StatelessWidget {
  const CheckOutItemsCard({
    super.key,
    required this.index,
    this.image,
    this.productName,
    this.productPrice,
    this.productOfferPrice,
    this.productQuantity,
    this.prescription,
  });

  final String? image;
  final String? productName;
  final String? productPrice;
  final String? productOfferPrice;
  final String? productQuantity;
  final bool? prescription;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CustomCachedNetworkImage(image: image!),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName ?? 'Unkown product',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          const Gap(8),
                          pharmacyProvider.pharmacyCartProducts[index]
                                      .productDiscountRate ==
                                  null
                              ? RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Price - ',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: BColors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                        text: '₹$productPrice',
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
                                          text: 'Price - ',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: BColors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                        text: '₹$productPrice',
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontFamily: 'Montserrat',
                                            color: BColors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: '  ₹$productOfferPrice',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: BColors.green,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                          if (prescription == true)
                            Column(
                              children: [
                                const Gap(8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      BIcon.rxIcon,
                                      height: 16,
                                    ),
                                    const Gap(4),
                                     Text(
                                      'This item requires a prescription.',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                          color: BColors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              QuantitiyBox(productQuantity: productQuantity)
            ],
          ),
        ),
      );
    });
  }
}
