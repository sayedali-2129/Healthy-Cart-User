import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/widgets/phone_field.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    return Consumer<AuthenticationProvider>(
        builder: (context, authenticationProvider, _) {
      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: BColors.white,
          backgroundColor: BColors.white,
          leading:   GestureDetector(
                                onTap: () {
                                  EasyNavigation.pushAndRemoveUntil(
                                      context: context,
                                      page: const BottomNavigationWidget());
                                },
                                child: const Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: screenheight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Gap(88),
                          SizedBox(
                            child: Center(
                              child: Image.asset(
                                  height: 260, width: 218, BImage.loginImage),
                            ),
                          ),
                          const Gap(48),
                          const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          const Gap(16),
                          const SizedBox(
                            width: 300,
                            child: Text(
                              'Please select your Country code & enter the Phone number. ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Gap(20),
                          PhoneField(
                            phoneNumberController:
                                authenticationProvider.phoneNumberController,
                            countryCode: (value) {
                              authenticationProvider.countryCode = value;
                            },
                          ),
                          const Gap(40),
                          ButtonWidget(
                            buttonWidth: double.infinity,
                            buttonHeight: 48,
                            onPressed: () async {
                              if (authenticationProvider.countryCode == null)
                                return;
                              if (authenticationProvider
                                      .phoneNumberController.text.isEmpty ||
                                  authenticationProvider
                                          .phoneNumberController.text.length <
                                      10 ||
                                  authenticationProvider
                                          .phoneNumberController.text.length >
                                      10) {
                                CustomToast.sucessToast(
                                    text: 'Please re-enter a valid number');
                                return;
                              }
                              LoadingLottie.showLoading(
                                  context: context, text: 'Sending OTP...');

                              authenticationProvider.setNumber();
                              authenticationProvider.verifyPhoneNumber(
                                  context: context);
                            },
                            buttonWidget: const Text(
                              'Sent OTP',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: BColors.white),
                            ),
                            buttonColor: BColors.buttonDarkColor,
                          ),
                          const Gap(24),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }
}
