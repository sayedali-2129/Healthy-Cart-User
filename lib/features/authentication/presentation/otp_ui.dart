import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/widgets/pinput.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen(
      {super.key, required this.phoneNumber});
  final String phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late int seconds;
  int resendTimer = 30;
  Timer? timer;
  @override
  void initState() {
    seconds = resendTimer;
    setTimer();
    super.initState();
  }

  void setTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          surfaceTintColor: BColors.white,
          backgroundColor: BColors.white,
          leading: InkWell(
              onTap: () {
                EasyNavigation.pop(context: context);
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
        ),
        body: Consumer<AuthenticationProvider>(
            builder: (context, authenticationProvider, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(88),
                    SizedBox(
                      child: Center(
                        child: Image.asset(
                            height: 260, width: 218, BImage.otpImage),
                      ),
                    ),
                    const Gap(48),
                    const Text(
                      'Verification',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                        width: 300,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text:
                                      'Please enter the One Time Password we sent on via sms ',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: BColors.black)),
                              TextSpan(
                                text: widget.phoneNumber,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )),
                    const Gap(40),
                    PinputWidget(
                        onSubmitted: (_) {}, controller: otpController),
                    const Gap(40),
                    ButtonWidget(
                      buttonWidth: double.infinity,
                      buttonHeight: 48,
                      onPressed: () {
                        LoadingLottie.showLoading(
                            context: context, text: 'Verifying OTP...');
                        authenticationProvider.verifySmsCode(
                            smsCode: otpController.text.trim(),
                            context: context);
                        authenticationProvider.phoneNumberController.clear();
                      },
                      buttonWidget: const Text(
                        'Verify Code',
                        style: TextStyle(fontSize: 18, color: BColors.white,fontWeight: FontWeight.w600),
                      ),
                      buttonColor: BColors.buttonLightColor,
                    ),
                    const Gap(24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: "Didn't get OTP ?  ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                 fontFamily: 'Montserrat',
                                 color: BColors.textLightBlack
                              )),
                          (seconds == 0)
                              ? TextSpan(
                                  text: 'Resend',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                       fontFamily: 'Montserrat',
                                 color: BColors.textBlack
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      LoadingLottie.showLoading(
                                          context: context, text: 'Loading...');
                                      authenticationProvider.verifyPhoneNumber(
                                          context: context, resend: true);
                                    })
                              : TextSpan(
                                  text: 'in 00:$seconds',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat',
                                 color: BColors.textLightBlack
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
