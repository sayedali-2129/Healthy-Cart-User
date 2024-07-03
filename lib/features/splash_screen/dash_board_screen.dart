import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Animate(
        child: Container(
          height: screenheight,
          // color: Colors.amber,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 170,
                      width: screenwidth,
                      decoration: const BoxDecoration(
                          color: BColors.darkblue,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(165, 70),
                              bottomRight: Radius.elliptical(165, 70))),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              BImage.transparentLogo,
                              scale: 2.7,
                              // width: 227,
                              // height: 48,
                            ).animate().slideY(
                                  begin: -100,
                                  curve: Curves.decelerate,
                                  delay: const Duration(milliseconds: 1400),
                                  duration: const Duration(milliseconds: 1500),
                                ),
                            Image.asset(
                              BImage.hcTextPng,
                              width: 227,
                              height: 48,
                            )
                          ],
                        ),
                      ),
                    ).animate().slideY(
                          begin: -100,
                          curve: Curves.decelerate,
                          delay: const Duration(milliseconds: 1400),
                          duration: const Duration(milliseconds: 1500),
                        ),
                  ],
                ),
                Gap(50),
                /////////////////// HEALTHYCART TOP IMAGE PNG ////////////////

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //////////////// LOGO ////////////////
                        Image.asset(
                          BImage.roundedLogo,
                          height: 100,
                          width: 100,
                        ).animate().slide(
                            // end: const Offset(-1, -3.55),
                            end: const Offset(-2, -5.55),
                            curve: Curves.decelerate,
                            delay: const Duration(milliseconds: 2500),
                            duration: const Duration(milliseconds: 500)),
                        const Gap(22),
                        /////////////////// TEXT UNDER LOGO ///////////
                        Image.asset(
                          BImage.smallText,
                          height: 10,
                          width: 114,
                        ).animate().slideY(
                            end: -100,
                            curve: Curves.decelerate,
                            delay: const Duration(milliseconds: 2500),
                            duration: const Duration(milliseconds: 200)),
                      ],
                    )
                        .animate()
                        .slideY(
                          begin: -100,
                          curve: Curves.decelerate,
                          delay: const Duration(seconds: 0),
                          duration: const Duration(milliseconds: 1500),
                        )
                        .shake(
                            rotation: 0,
                            duration: const Duration(milliseconds: 1000),
                            offset: const Offset(0, 150),
                            delay: const Duration(milliseconds: 1300),
                            hz: 0.5,
                            curve: Curves.decelerate)
                        .shakeY(
                          curve: Curves.decelerate,
                          delay: const Duration(milliseconds: 2000),
                          duration: const Duration(milliseconds: 1000),
                          hz: 1,
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Container(
                          // color: Colors.red,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ////////////////////////// GET STARTED PNG //////////////////
                              Image.asset(
                                  width: 218, height: 300, BImage.getStarted),

                              const Text('Get things done with HEALTHY CART',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800)),
                              const Gap(16),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            'Discover a world of wellness at ',
                                        style: TextStyle(
                                            color: BColors.black,
                                            height: 1.8,
                                            fontFamily: 'Montserrat')),
                                    TextSpan(
                                        text: 'HEALTHYCART',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: BColors.black,
                                            height: 1.8,
                                            fontFamily: 'Montserrat')),
                                    TextSpan(
                                        text:
                                            ', your ultimate destination for all things health and well-being',
                                        style: TextStyle(
                                            height: 1.8,
                                            color: BColors.black,
                                            fontFamily: 'Montserrat'))
                                  ])),

                              // GestureDetector(
                              //   onTap: () {
                              //     EasyNavigation.pushAndRemoveUntil(
                              //         context: context,
                              //         duration: 250,
                              //         page: const SplashScreen());
                              //   },
                              //   child: Container(
                              //     width: double.infinity,
                              //     height: 54,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(16),
                              //       color: const Color(0xff50C2C9),
                              //     ),
                              //     child: const Center(
                              //         child: Text(
                              //       'Get Started',
                              //       style: TextStyle(
                              //           fontSize: 18,
                              //           fontWeight: FontWeight.w600,
                              //           color: Colors.white),
                              //     )),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 3000)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          EasyNavigation.pushAndRemoveUntil(
              context: context, duration: 250, page: const SplashScreen());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
                color: BColors.mainlightColor,
                borderRadius: BorderRadius.circular(16)),
            child: const Center(
                child: Text(
              'Get Started',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
          ).animate().slide(
              begin: const Offset(0, 10),
              end: const Offset(0, 0),
              duration: 200.milliseconds,
              delay: const Duration(milliseconds: 3000)),
        ),
      ),
    );
  }
}
