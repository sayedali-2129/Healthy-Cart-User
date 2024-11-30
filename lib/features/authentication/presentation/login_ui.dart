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
    return Consumer<AuthenticationProvider>(
        builder: (context, authenticationProvider, _) {
      return Scaffold(
        
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppBar(
          surfaceTintColor: BColors.white,
          backgroundColor: BColors.white,
        leadingWidth: 2,
          leading: IconButton(onPressed: (){
                            EasyNavigation.pushReplacement(
                    context: context, page: const BottomNavigationWidget());
          }, icon: const Icon(Icons.arrow_back_ios_new_rounded),),

        ),
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
                    const Gap(40),
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
                        FocusScope.of(context).unfocus();
                        if (authenticationProvider.countryCode == null){
                          CustomToast.errorToast(
                              text: 'Please select your country code');
                        return;
                        }
                     
                        if (authenticationProvider
                                .phoneNumberController.text.isEmpty ||
                            authenticationProvider
                                    .phoneNumberController.text.length <
                                6 ||
                            authenticationProvider
                                    .phoneNumberController.text.length >
                                12) {
                          CustomToast.errorToast(
                              text: 'Please re-enter a valid number');
                          return;
                        }
                        LoadingLottie.showLoading(
                            context: context, text: 'Sending OTP...');
                        
                        authenticationProvider.setNumber();
                        authenticationProvider.verifyPhoneNumber(
                            context: context, resend: false);
                      },
                      buttonWidget: const Text(
                        'Sent OTP',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: BColors.white),
                      ),
                      buttonColor: BColors.buttonDarkColor,
                    ),
                    const Gap(24),
                  ],
                ),
            ),
          ),
        ),
      );
    });
  }
}
