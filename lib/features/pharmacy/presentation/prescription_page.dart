import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/prescription_bottom_sheet/precription_bottomsheet.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/prescription_image_widget.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    final addressProvider = Provider.of<UserAddressProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: Scaffold(
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
                    pharmacyProvider.prescriptionImageFile == null
                        ? Image.asset(BImage.prescriptionImage)
                        : Column(
                            children: [
                              PrescriptionImageWidget(
                                pharmacyProvider: pharmacyProvider,
                                height: 320,
                                width: 320,
                              ),
                              const Gap(24)
                            ],
                          ),
                    pharmacyProvider.prescriptionImageFile == null
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
                                      pharmacyProvider
                                          .getImage(
                                              imagesource: ImageSource.camera)
                                          .whenComplete(() =>
                                              EasyNavigation.pop(
                                                  context: context));
                                    },
                                    galleryButtonTap: () {
                                      pharmacyProvider
                                          .getImage(
                                              imagesource: ImageSource.gallery)
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
                              pharmacyProvider.setDeliveryAddressAndUserData(
                                  userData:
                                      authProvider.userFetchlDataFetched ??
                                          UserModel(),
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
                            buttonHeight: 40,
                            buttonWidth: double.infinity,
                            buttonColor: BColors.lightgreen,
                            buttonWidget: const Text(
                              'Send for review',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: BColors.black),
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
