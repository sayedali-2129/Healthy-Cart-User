import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/prescription_bottom_sheet/precription_bottomsheet.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_prescription_order_address_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_prescription_image_widget.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_type_radio.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LabPrescriptionPage extends StatelessWidget {
  const LabPrescriptionPage({super.key, required this.labModel});
  final LabModel labModel;

  @override
  Widget build(BuildContext context) {
    final labProvider = Provider.of<LabProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final addressProvider = Provider.of<UserAddressProvider>(context);
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          labProvider.clearCurrentDetails();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
              title: 'Prescription',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    labProvider.prescriptionFile == null
                        ? Image.asset(BImage.prescriptionImage)
                        : Column(
                            children: [
                              LabPrescriptionImageWidget(
                                labProvider: labProvider,
                                height: 320,
                                width: 320,
                              ),
                              const Gap(24)
                            ],
                          ),
                    labProvider.prescriptionFile == null
                        ? ButtonWidget(
                            onPressed: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                elevation: 10,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return ChoosePrescriptionBottomSheet(
                                    cameraButtonTap: () {
                                      labProvider
                                          .pickPrescription(
                                              source: ImageSource.camera)
                                          .whenComplete(() =>
                                              EasyNavigation.pop(
                                                  context: context));
                                    },
                                    galleryButtonTap: () {
                                      labProvider
                                          .pickPrescription(
                                              source: ImageSource.gallery)
                                          .whenComplete(() =>
                                              EasyNavigation.pop(
                                                  context: context));
                                    },
                                  );
                                },
                              );
                            },
                            buttonHeight: 40,
                            buttonWidth: double.infinity,
                            buttonColor: BColors.darkblue,
                            buttonWidget: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_upload_outlined,
                                  color: BColors.white,
                                  size: 24,
                                ),
                                Gap(8),
                                Text(
                                  'Upload Prescription',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: BColors.white),
                                ),
                              ],
                            ),
                          )
                        : ButtonWidget(
                            onPressed: () {
                              if (authProvider
                                      .userFetchlDataFetched!.userName ==
                                  null) {
                                EasyNavigation.push(
                                    context: context,
                                    page: const ProfileSetup());
                                CustomToast.infoToast(
                                    text: 'Fill user details');
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => TestTypeRadiopopup(
                                    onConfirm: () {
                                      if (labProvider.selectedRadio == 'Lab') {
                                        ConfirmAlertBoxWidget
                                            .showAlertConfirmBox(
                                                context: context,
                                                titleText: 'Confirm Order',
                                                subText:
                                                    'This will send your order to the laboratory and check the availability of the test. Are you sure you want to proceed?',
                                                confirmButtonTap: () async {
                                                  LoadingLottie.showLoading(
                                                      context: context,
                                                      text: 'Please wait...');

                                                  if (labProvider
                                                          .prescriptionFile !=
                                                      null) {
                                                    await labProvider
                                                        .uploadPrescription();
                                                  }
                                                  await labProvider.addLabOrders(
                                                      prescriptionOnly: true,
                                                      selectedTests: [],
                                                      labModel: labModel,
                                                      labId: labModel.id!,
                                                      userId: authProvider
                                                          .userFetchlDataFetched!
                                                          .id!,
                                                      userModel: authProvider
                                                          .userFetchlDataFetched!,
                                                      selectedAddress:
                                                          addressProvider
                                                                  .selectedAddress ??
                                                              UserAddressModel(),
                                                      fcmtoken:
                                                          labModel.fcmToken!,
                                                      userName: authProvider
                                                          .userFetchlDataFetched!
                                                          .userName!);

                                                  labProvider.selectedRadio =
                                                      null;
                                                  addressProvider
                                                      .selectedAddress = null;
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const OrderRequestSuccessScreen(
                                                        title:
                                                            'Your Laboratory appointment is currently being processed. We will notify you once its confirmed',
                                                      ),
                                                    ),
                                                    (route) => false,
                                                  );
                                                  labProvider
                                                      .clearCurrentDetails();
                                                });
                                      } else {
                                        EasyNavigation.push(
                                            context: context,
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration: 250,
                                            page:
                                                LabPrescriptionOrderAddressScreen(
                                              labModel: labModel,
                                              userId: authProvider
                                                      .userFetchlDataFetched!
                                                      .id ??
                                                  '',
                                            ));
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                            buttonHeight: 40,
                            buttonWidth: double.infinity,
                            buttonColor: BColors.lightgreen,
                            buttonWidget: const Text(
                              'Send for review',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: BColors.black,
                              ),
                            ),
                          ),
                    const Gap(24),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Upload the prescription and it send for review.Our pharmacist will review it and add the items to your cart accordingly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                            color: BColors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
