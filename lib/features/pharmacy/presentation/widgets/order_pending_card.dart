import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/checkout_item_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyPendingCard extends StatelessWidget {
  const PharmacyPendingCard({
    super.key,
    required this.screenWidth,
    required this.index,
  });

  final double screenWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyOrderProvider>(
        builder: (context, ordersProvider, _) {
      final orders = ordersProvider.pendingOrders[index];
      return Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BColors.black.withOpacity(0.3),
              blurRadius: 5,
            ),
          ],
        ),
        child:
            //MAIN COLUMN
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 64,
                      width: 64,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CustomCachedNetworkImage(
                          image: orders.pharmacyDetails?.pharmacyImage ?? '')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your order is on pending',
                            style: TextStyle(
                                color: Color(0xffEB9025),
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                          const Gap(6),
                          const Text(
                            'Items Ordered :',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const Gap(6),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                ListView.builder(
                                  padding: const EdgeInsets.only(
                                    left: 6,
                                    right: 8,
                                    top: 8,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: orders.productDetails?.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                '${orders.productDetails?[index].productData?.productName}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Flexible(
                                                flex: 1,
                                                child: QuantitiyBox(
                                                    productQuantity: orders
                                                        .productDetails?[index]
                                                        .quantity
                                                        .toString())),
                                          ],
                                        ),
                                        const Gap(6),
                                      ],
                                    );
                                  },
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                          text: 'Amount to be paid : ',
                                          style: TextStyle(
                                            color: BColors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            fontFamily: 'Montserrat',
                                          )),
                                      TextSpan(
                                        text: '₹ ${orders.totalAmount}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(6),
                              ],
                            ),
                          ),
                          const Gap(4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            '${orders.pharmacyDetails?.pharmacyName} ',
                                        style: const TextStyle(
                                          color: BColors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                        )),
                                    TextSpan(
                                      text: orders
                                          .pharmacyDetails!.pharmacyAddress,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: BColors.black),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlineButtonWidget(
                    buttonHeight: 35,
                    buttonWidth: 140,
                    buttonColor: BColors.white,
                    borderColor: BColors.black,
                    buttonWidget: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: BColors.black, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      ConfirmAlertBoxWidget.showAlertConfirmBox(
                        context: context,
                        titleSize: 18,
                        titleText: 'Cancel',
                        subText: 'Are you sure you want to cancel this order?',
                        confirmButtonTap: () {
                          LoadingLottie.showLoading(
                              context: context, text: 'Cancelling...');
                          ordersProvider
                              .cancelPendingOrder(
                                  index: index,
                                  orderProductId: orders.id ?? '')
                              .whenComplete(() => Navigator.pop(context));
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
