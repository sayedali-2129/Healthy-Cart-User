import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/address_card.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class LabPrescriptionOrderAddressScreen extends StatefulWidget {
  const LabPrescriptionOrderAddressScreen(
      {super.key, this.userId, required this.labModel});
  final String? userId;
  final LabModel labModel;

  @override
  State<LabPrescriptionOrderAddressScreen> createState() =>
      _LabPrescriptionOrderAddressScreenState();
}

class _LabPrescriptionOrderAddressScreenState
    extends State<LabPrescriptionOrderAddressScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = context.read<UserAddressProvider>();
      final labProvider = context.read<LabProvider>();
      if (labProvider.selectedRadio == 'Home') {
        addressProvider.getUserAddress(userId: widget.userId ?? '');
      }
      log(addressProvider.selectedAddress.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<UserAddressProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final labProvider = Provider.of<LabProvider>(context);
    return Scaffold(
      body: PopScope(
        onPopInvoked: (didPop) {
          labProvider.selectedRadio = null;
        },
        child: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
              title: 'Address',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              },
            ),
            if (addressProvider.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: LoadingIndicater(),
                ),
              )
            else
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
                      if (labProvider.selectedRadio == 'Home') const Divider(),
                      FadeInRight(child: const AddressCard()),
                      const Divider(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (labProvider.selectedRadio == 'Home' &&
              addressProvider.selectedAddress == null) {
            CustomToast.errorToast(text: 'Please select an address.');
            return;
          }
          if (labProvider.prescriptionFile == null) {
            CustomToast.errorToast(text: 'Please add a prescription.');
            return;
          }

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
                await labProvider
                    .addLabOrders(
                        prescriptionOnly: true,
                        selectedTests: [],
                        labModel: widget.labModel,
                        labId: widget.labModel.id!,
                        userId: authProvider.userFetchlDataFetched!.id!,
                        userModel: authProvider.userFetchlDataFetched!,
                        selectedAddress: addressProvider.selectedAddress,
                        fcmtoken: widget.labModel.fcmToken!,
                        userName: authProvider.userFetchlDataFetched!.userName!)
                    .whenComplete(
                  () {
                    labProvider.clearCurrentDetails();
                    addressProvider.selectedAddress == null;
                  },
                );

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
              });
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
