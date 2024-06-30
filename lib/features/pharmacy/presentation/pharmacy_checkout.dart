import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/prescription_bottom_sheet/precription_bottomsheet.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/address_card.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/checkout_item_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/order_summary_pharmacy.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/prescription_image_widget.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PharmacyCheckOutScreen extends StatefulWidget {
  const PharmacyCheckOutScreen({super.key});

  @override
  State<PharmacyCheckOutScreen> createState() => _PharmacyCheckOutScreenState();
}

class _PharmacyCheckOutScreenState extends State<PharmacyCheckOutScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final addressProvider = context.read<UserAddressProvider>();
        final pharmacyProvider = context.read<PharmacyProvider>();
        pharmacyProvider.clearProductAndUserInCheckOutDetails();

        for (int i = 0; i < pharmacyProvider.pharmacyCartProducts.length; i++) {
          pharmacyProvider.productDetails(
            quantity: pharmacyProvider.productCartQuantityList[i],
            productToCartDetails: pharmacyProvider.pharmacyCartProducts[i],
            id: pharmacyProvider.productCartIdList[i],
          );
        }
        if (pharmacyProvider.selectedRadio == 'Home') {
          addressProvider.getUserAddress(userId: pharmacyProvider.userId ?? '');
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    final addressProvider = Provider.of<UserAddressProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
            title: 'Check Out',
            onBackTap: () {
              EasyNavigation.pop(context: context);
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(8),
                  pharmacyProvider.selectedRadio == 'Home'
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
                                            '${pharmacyProvider.selectedpharmacyData?.pharmacyName}- ',
                                        style: const TextStyle(
                                          color: BColors.black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                        )),
                                    TextSpan(
                                      text: pharmacyProvider
                                              .selectedpharmacyData
                                              ?.pharmacyAddress ??
                                          'Unknown Address',
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
                      itemCount: pharmacyProvider.pharmacyCartProducts.length,
                      itemBuilder: (context, index) {
                        return CheckOutItemsCard(
                          index: index,
                          image: pharmacyProvider.pharmacyCartProducts[index]
                                  .productImage?.first ??
                              '',
                          productOfferPrice:
                              '${pharmacyProvider.pharmacyCartProducts[index].productDiscountRate}',
                          productPrice:
                              '${pharmacyProvider.pharmacyCartProducts[index].productMRPRate}',
                          productName:
                              '${pharmacyProvider.pharmacyCartProducts[index].productName}',
                          productQuantity:
                              '${pharmacyProvider.productCartQuantityList[index]}',
                          prescription: pharmacyProvider
                              .pharmacyCartProducts[index].requirePrescription,
                        );
                      }),
                  const Gap(8),
                  /* ------------------------- TOTAL AMOUNT CONTAINER ------------------------- */
                  OrderSummaryPharmacyCard(
                    totalProductPrice: pharmacyProvider.totalAmount,
                    discount: (pharmacyProvider.totalAmount -
                        pharmacyProvider.totalFinalAmount),
                    totalAmount: pharmacyProvider.totalFinalAmount,
                  ),
                  const Gap(12),
                  const Divider(),
                  const Gap(8),
                  pharmacyProvider.pharmacyCartProducts
                          .any((element) => element.requirePrescription == true)
                      ? Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.priority_high_rounded,
                                    color: Colors.red, size: 18),
                                Expanded(
                                  child: Text(
                                    'One or more products in your list require prescription, Kindly upload the prescription to proceed.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: BColors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            pharmacyProvider.prescriptionImageFile == null
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
                                      showModalBottomSheet(
                                        showDragHandle: true,
                                        elevation: 10,
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (context) {
                                          return ChoosePrescriptionBottomSheet(
                                            cameraButtonTap: () {
                                              pharmacyProvider
                                                  .getImage(
                                                      imagesource:
                                                          ImageSource.camera)
                                                  .whenComplete(() =>
                                                      EasyNavigation.pop(
                                                          context: context));
                                            },
                                            galleryButtonTap: () {
                                              pharmacyProvider
                                                  .getImage(
                                                      imagesource:
                                                          ImageSource.gallery)
                                                  .whenComplete(() =>
                                                      EasyNavigation.pop(
                                                          context: context));
                                            },
                                          );
                                        },
                                      );
                                    },
                                  )
                                : Column(
                                    children: [
                                      PrescriptionImageWidget(pharmacyProvider: pharmacyProvider),
                                    ],
                                  )
                          ],
                        )
                      : const Gap(0),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          log('pharmacy product and quantity details :::${pharmacyProvider.productAndQuantityDetails.length}');
          if (pharmacyProvider.selectedRadio == 'Home' &&
              addressProvider.selectedAddress == null) {
            CustomToast.errorToast(text: 'Please select an address.');
            return;
          }
          if (pharmacyProvider.prescriptionImageFile == null &&
              pharmacyProvider.pharmacyCartProducts
                  .any((element) => element.requirePrescription == true)) {
            CustomToast.errorToast(text: 'Please add a prescription.');
            return;
          }
          ConfirmAlertBoxWidget.showAlertConfirmBox(
              context: context,
              confirmButtonTap: () {
                pharmacyProvider.setDeliveryAddressAndUserData(
                    userData: authProvider.userFetchlDataFetched ?? UserModel(),
                    address: addressProvider.selectedAddress);
                LoadingLottie.showLoading(
                    context: context, text: 'Please wait...');
                pharmacyProvider.saveImage().whenComplete(
                  () {
                     pharmacyProvider.createProductOrderDetails(
                        context: context);
                  },
                );
              },
              titleText: 'Confirm Order',
              subText:  pharmacyProvider.pharmacyCartProducts
                          .any((element) => element.requirePrescription == true) ?"Tap on 'YES' to check the prescription of  items in your cart by the pharmacy. Are you sure you want to proceed ?" : 'Are you sure you want to proceed, please tap YES confirm ?');
        },
        child: Container(
          height: 60,
          color: BColors.mainlightColor,
          child: const Center(
            child: Text(
              'Continue',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: BColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
