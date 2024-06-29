// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/image_view/image_view.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ad_slider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/address_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/cart_items_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/order_summary_card.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
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
    final labProvider = context.read<LabProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log(labProvider.selectedRadio.toString());
      if (labProvider.selectedRadio == 'Home') {
        log('called');
        provider.getUserAddress(userId: widget.userId);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LabProvider, UserAddressProvider>(
        builder: (context, labProvider, addressProvider, _) {
      // log(addressProvider.selectedAddress!.toMap().toString());

      return PopScope(
        onPopInvoked: (didPop) {
          addressProvider.selectedAddress = null;
          labProvider.prescriptionFile = null;
          labProvider.prescriptionUrl = null;
        },
        child: Scaffold(
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
                                      text: TextSpan(
                                        children: [
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
                                        ],
                                      ),
                                    ),
                                  )
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
                                testPrice: labProvider
                                    .cartItems[index].testPrice
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
                                  CustomToast.sucessToast(text: 'Test Removed');
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
                        const Gap(12),
                        /* ------------------------------ PRESCRIPTION ------------------------------ */
                        labProvider.cartItems
                                .any((item) => item.prescriptionNeeded == true)
                            ? Column(
                                children: [
                                  const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.priority_high_rounded,
                                          color: Colors.red, size: 18),
                                      Expanded(
                                        child: Text(
                                          'One or more tests in your list require prescription, Kindly upload the prescription to proceed',
                                          style: TextStyle(
                                              color: BColors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(8),
                                  labProvider.prescriptionFile == null
                                      ? ButtonWidget(
                                          buttonHeight: 36,
                                          buttonWidth: 160,
                                          buttonColor: BColors.buttonGreen,
                                          buttonWidget: const Row(
                                            children: [
                                              Icon(
                                                Icons.maps_ugc_outlined,
                                                color: BColors.black,
                                                size: 19,
                                              ),
                                              Gap(5),
                                              Text(
                                                'Prescription',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: BColors.black),
                                              )
                                            ],
                                          ),
                                          onPressed: () {
                                            labProvider.pickPrescription();
                                          },
                                        )
                                      : Column(
                                          children: [
                                            SizedBox(
                                              width: 110,
                                              height: 130,
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      EasyNavigation.push(
                                                        context: context,
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        duration: 200,
                                                        page: ImageView(
                                                          imageFile: labProvider
                                                              .prescriptionFile!,
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      height: 120,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Image.file(
                                                        labProvider
                                                            .prescriptionFile!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          BColors.red,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          labProvider
                                                              .clearImageFile();
                                                        },
                                                        child: const Icon(
                                                          Icons.close_rounded,
                                                          color: BColors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              )
                            : const Gap(0),
                        const Gap(12),
                        /* --------------------------------- BANNER --------------------------------- */
                        AdSlider(
                            screenWidth: double.infinity,
                            labId: labProvider.labList[widget.index].id!)
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              bool checkPrescription = labProvider.cartItems
                  .any((item) => item.prescriptionNeeded == true);
              if (labProvider.selectedRadio == 'Home' &&
                  addressProvider.selectedAddress == null) {
                CustomToast.infoToast(text: 'Please select address');
              } else if (checkPrescription &&
                  labProvider.prescriptionFile == null) {
                CustomToast.infoToast(text: 'Please upload prescription');
              } else {
                ConfirmAlertBoxWidget.showAlertConfirmBox(
                    context: context,
                    titleText: 'Confirm Order',
                    subText:
                        'This will send your order to the laboratory and check the availability of the test. Are you sure you want to proceed?',
                    confirmButtonTap: () async {
                      LoadingLottie.showLoading(
                          context: context, text: 'Please wait...');

                      if (labProvider.prescriptionFile != null) {
                        await labProvider.uploadPrescription();
                      }
                      await labProvider.addLabOrders(
                          labModel: labProvider.labList[widget.index],
                          labId: labProvider.labList[widget.index].id!,
                          userId: widget.userId,
                          userModel: widget.userModel!,
                          selectedAddress: addressProvider.selectedAddress ??
                              UserAddressModel(),
                          fcmtoken: labProvider.labList[widget.index].fcmToken!,
                          userName: widget.userModel!.userName!);
                      labProvider.clearCart();
                      labProvider.selectedRadio = null;
                      addressProvider.selectedAddress = null;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderRequestSuccessScreen(
                            title:
                                'Your Laboratory appointment is currently being processed. We will notify you once its confirmed',
                          ),
                        ),
                        (route) => false,
                      );
                      labProvider.prescriptionFile = null;
                      labProvider.prescriptionUrl = null;
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
              ),
            ),
          ),
        ),
      );
    });
  }
}
