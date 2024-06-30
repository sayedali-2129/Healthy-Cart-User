import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_details.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_count_add.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
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
                child: InkWell(
                  onTap: () {
                    pharmacyProvider.productImageUrlList =
                        productData.productImage ?? [];
                    EasyNavigation.push(
                      context: context,
                      type: PageTransitionType.bottomToTop,
                      page: ProductDetailsScreen(
                        productData: productData,
                        fromCart: false,
                      ),
                    );
                  },
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
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                              color: BColors.green),
                                        ),
                                        TextSpan(
                                          text:
                                              '${productData.productMRPRate ?? 'Unkown Price'}',
                                          style: TextStyle(
                                              fontSize: 15,
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
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                color: BColors.green)),
                                        TextSpan(
                                          text:
                                              "${productData.productDiscountRate}",
                                          style: TextStyle(
                                              fontSize: 15,
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
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontFamily: 'Montserrat',
                                                color: BColors.textBlack)),
                                        TextSpan(
                                          text: "${productData.productMRPRate}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontFamily: 'Montserrat',
                                              color: BColors.textBlack),
                                        ),
                                      ]),
                                    ),
                              
                              if(productData.inStock == false)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor: BColors.red,
                                  ),
                                 const  Gap(4),
                                 const Text(
                                                            'Out of stock',
                                                            style:  TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: BColors.black),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.left,
                                                      ),
                                ],
                                                            ),
                              ),
                              const Gap(16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  QuantityCountWidget(
                                    incrementTap: () {
                                      pharmacyProvider.incrementInCart(
                                        index: index,
                                        productMRPRate:
                                            productData.productMRPRate!,
                                        productDiscountRate: productData
                                                    .productDiscountRate ==
                                                null
                                            ? productData.productMRPRate!
                                            : productData.productDiscountRate!,
                                      );
                                      pharmacyProvider.addProductToUserCart(
                                        productId: productData.id ?? '',
                                        selectedQuantityCount: pharmacyProvider
                                            .productCartQuantityList[index],
                                        cartQuantityIncrement: true,// this is to make the custom toast accordingly
                                      );
                                    },
                                    decrementTap: () {
                                      pharmacyProvider.decrementInCart(
                                        index: index,
                                        productMRPRate:
                                            productData.productMRPRate!,
                                        productDiscountRate: productData
                                                    .productDiscountRate ==
                                                null
                                            ? productData.productMRPRate!
                                            : productData.productDiscountRate!,
                                      );
                                      pharmacyProvider.addProductToUserCart(
                                        productId: productData.id ?? '',
                                        selectedQuantityCount: pharmacyProvider
                                            .productCartQuantityList[index],
                                        cartQuantityIncrement: false,
                                      );
                                    },
                                    quantityValue: pharmacyProvider
                                        .productCartQuantityList[index],
                                  ),
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
              ),
              Positioned(
                  top: -1,
                  right: -1,
                  child: IconButton(
                      onPressed: () {
                        ConfirmAlertBoxWidget.showAlertConfirmBox(
                            context: context,
                            confirmButtonTap: () {
                              LoadingLottie.showLoading(
                                  context: context, text: 'Please wait...');
                              pharmacyProvider
                                  .removeProductFromUserCart(
                                      productData: productData, index: index,)
                                  .whenComplete(
                                () {
                                  EasyNavigation.pop(context: context);
                                },
                              );
                            },
                            titleText: 'Remove this item from cart',
                            subText: 'Are you sure you want to proceed ?');
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: BColors.red,
                        size: 28,
                      )))
            ],
          ),
        ),
      );
    });
  }
}
