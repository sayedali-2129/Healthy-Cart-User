import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/order_request_success.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ad_slider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/address_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/cart_items_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/order_summary_card.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key, required this.index, required this.userId, this.userModel});
  final int index;
  final String userId;
  final UserModel? userModel;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    final provider = context.read<UserAddressProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getUserAddress(userId: widget.userId);
    });
    // log(provider.selectedAddress!.toMap().toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LabProvider, UserAddressProvider>(
        builder: (context, labProvider, addressProvider, _) {
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
        body: addressProvider.isLoading == true
            ? const Center(child: LoadingIndicater())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(8),
                      labProvider.selectedRadio == 'Home'
                          ? const AddressCard()
                          : Row(
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
                                                  '${labProvider.labList[widget.index].laboratoryName}- ',
                                              style: const TextStyle(
                                                color: BColors.black,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                              )),
                                          TextSpan(
                                            text: labProvider
                                                    .labList[widget.index]
                                                    .address ??
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
                            return CartItemsCard(
                              index: index,
                              testName: labProvider.cartItems[index].testName,
                              testPrice: labProvider.cartItems[index].testPrice
                                  .toString(),
                              offerPrice: labProvider
                                  .cartItems[index].offerPrice
                                  .toString(),
                              image: labProvider.cartItems[index].testImage,
                              onDelete: () {
                                labProvider.removeFromCart(index);
                                if (labProvider.cartItems.isEmpty) {
                                  Navigator.pop(context);
                                }
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
                          labId: labProvider.labList[widget.index].id!)
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            log(addressProvider.selectedAddress!.toMap().toString());
            if (labProvider.selectedRadio == 'Home' &&
                addressProvider.selectedAddress == null) {
              CustomToast.errorToast(text: 'Please select address');
            } else {
              ConfirmAlertBoxWidget.showAlertConfirmBox(
                  context: context,
                  titleText: 'Confirm Order',
                  subText:
                      'This will send your order to the laboratory and check the availability of the test. Are you sure you want to proceed?',
                  confirmButtonTap: () {
                    labProvider.addLabOrders(
                      labId: labProvider.labList[widget.index].id!,
                      userId: widget.userId,
                      userModel: widget.userModel!,
                      selectedAddress:
                          addressProvider.selectedAddress ?? UserAddressModel(),
                    );
                    labProvider.clearCart();
                    labProvider.selectedRadio = null;
                    addressProvider.selectedAddress = null;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderRequestSuccessScreen(),
                      ),
                      (route) => false,
                    );
                  });
            }
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
