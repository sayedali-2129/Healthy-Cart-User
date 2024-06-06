import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/order_request_success.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ad_slider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/cart_items_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/order_summary_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: BColors.mainlightColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8))),
          title: const Text(
            'Check Out',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          shadowColor: BColors.black.withOpacity(0.8),
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${labProvider.cartItems.length} Test Selected',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Gap(8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                    ),
                    const Gap(5),
                    Expanded(
                        child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      '${labProvider.labList[index].laboratoryName}- ',
                                  style: const TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  )),
                              TextSpan(
                                text: labProvider.labList[index].address ??
                                    'No Address',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: BColors.black),
                              )
                            ])))
                  ],
                ),
                const Gap(8),
                const Divider(),
                const Gap(8),
                /* -------------------------------- CART LIST ------------------------------- */
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Gap(8),
                    itemCount: labProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      log(labProvider.cartItems.length.toString());
                      return CartItemsCard(
                        index: index,
                        testName: labProvider.cartItems[index].testName,
                        testPrice:
                            labProvider.cartItems[index].testPrice.toString(),
                        offerPrice:
                            labProvider.cartItems[index].offerPrice.toString(),
                        image: labProvider.cartItems[index].testImage,
                        onDelete: () {
                          labProvider.removeFromCart(index);
                        },
                      );
                    }),
                const Gap(8),
                /* -------------------------------------------------------------------------- */
                /* ------------------------- TOTAL AMOUNT CONTAINER ------------------------- */
                OrderSummaryCard(
                  totalTestFee: labProvider.claculateTotalTestFee(),
                  discount: labProvider.totalDicount(),
                  totalAmount: labProvider.claculateTotalAmount(),
                ),
                /* --------------------------------- BANNER --------------------------------- */
                const Gap(12),
                AdSlider(
                    screenWidth: double.infinity,
                    labId: labProvider.labList[index].id!)
              ],
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderRequestSuccessScreen(),
                ));
          },
          child: Container(
              height: 60,
              color: BColors.mainlightColor,
              child: const Center(
                child: Text(
                  'Check Availability',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: BColors.white),
                ),
              )),
        ),
      );
    });
  }
}
