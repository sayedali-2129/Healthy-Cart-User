import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location.dart';
import 'package:healthy_cart_user/features/notifications/application/provider/notification_provider.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final locationProvider = context.read<LocationProvider>();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final auth = FirebaseAuth.instance;
    final notiProvider = context.read<NotificationProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notiProvider.notificationPermission();
       locationProvider.getLocationLocally();
      if (userId != null) {
        context
            .read<AuthenticationProvider>()
            .userStreamFetchedData(userId: userId);
             
      }
    });
    Future.delayed(const Duration(seconds: 4)).then(
      (value) {
      
        if (auth.currentUser == null) {
          if (locationProvider.locallysavedplacemark == null) {
            EasyNavigation.pushAndRemoveUntil(
              context: context,
              page: const LocationPage(),
            );
          } else {
            EasyNavigation.pushAndRemoveUntil(
            context: context,
            page: const BottomNavigationWidget(),
          );
          }
          context
              .read<AuthenticationProvider>()
              .navigationUserFuction(context: context);
        } else {
          if (locationProvider.locallysavedplacemark == null) {
            EasyNavigation.pushAndRemoveUntil(
              context: context,
              page: const LocationPage(),
            );
          } else {
            EasyNavigation.pushAndRemoveUntil(
            context: context,
            page: const BottomNavigationWidget(),
          );
          }
        }
      },
    );

    /* ------------------------------ OLD FUNCTION ------------------------------ */
    // Future.delayed(const Duration(seconds: 4)).then((value) {
    //   if (userId == null) {
    //     EasyNavigation.pushReplacement(
    //         context: context, page: const LoginScreen());
    //   } else {
    //     context
    //         .read<AuthenticationProvider>()
    //         .navigationUserFuction(context: context);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenwidth = MediaQuery.of(context).size.width;
    // final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Animate(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ////////////////// LOGO ////////////////
                      Image.asset(
                        BImage.roundedSplashLogo,
                        height: 100,
                        width: 100,
                      ),
                      const Gap(22),
                      /////////////////// TEXT UNDER LOGO ///////////
                      Image.asset(
                        BImage.healthycartText,
                        height: 10,
                        width: 114,
                      )
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
