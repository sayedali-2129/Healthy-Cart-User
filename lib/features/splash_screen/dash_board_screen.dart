import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Animate(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: CustomClipperPath(),
                    child: Container(
                      width: double.infinity,
                      height: 260,
                      decoration: const BoxDecoration(
                        color: Color(0xff11334E),
                      ),
                    ),
                  ).animate().slideY(
                        begin: -100,
                        curve: Curves.decelerate,
                        delay: const Duration(milliseconds: 1400),
                        duration: const Duration(milliseconds: 1500),
                      ),

                  /////////////////// HEALTHYCART TOP IMAGE PNG ////////////////
                  Positioned(
                    right: 65,
                    child: Row(
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
                        ).animate().slideY(
                              begin: -100,
                              curve: Curves.decelerate,
                              delay: const Duration(milliseconds: 1400),
                              duration: const Duration(milliseconds: 1500),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      child: Column(
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
                          )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ////////////////////////// GET STARTED PNG //////////////////
                        Image.asset(width: 218, height: 184, BImage.getStarted),
                        const Gap(48),
                        const Text('Get things done with HEALTHY CART',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const Gap(16),
                        const Text(
                          "Discover a world of wellness at HEALTHYCART, your ultimate destination for all things health and well-being",
                          textAlign: TextAlign.center,
                        ),
                        const Gap(88),
                        GestureDetector(
                          onTap: () {
                            EasyNavigation.pushAndRemoveUntil(
                                context: context,
                                duration: 250,
                                page: const SplashScreen());
                          },
                          child: Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xff50C2C9),
                            ),
                            child: const Center(
                                child: Text(
                              'Get Started',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                          ),
                        )
                      ],
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 3000)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    //(0,0) first point
    path.lineTo(0, h - 100); // 2. point
    path.quadraticBezierTo(w * 0.5, h, w, h - 100); // 4. point
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
