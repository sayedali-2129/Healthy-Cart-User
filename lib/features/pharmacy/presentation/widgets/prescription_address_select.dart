import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/address_card.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PrescriptionOrderAddressScreen extends StatelessWidget {
  const PrescriptionOrderAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<UserAddressProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
            title: 'Address',
            onBackTap: () {
              EasyNavigation.pop(context: context);
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Delivery Address",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat'),
                  ),
                  const Gap(16),
                  if (pharmacyProvider.selectedRadio == 'Home')
                 const  Divider(),
                    const AddressCard(),
                     const  Divider(),  
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
              subText:
                  "Tap on 'YES' to check the prescription of  items in your cart by the pharmacy. Are you sure you want to proceed ?");
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
