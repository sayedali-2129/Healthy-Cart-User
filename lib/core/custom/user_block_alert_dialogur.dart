import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
import 'package:healthy_cart_user/main.dart';
import 'package:healthy_cart_user/utils/app_details.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class UserBlockedAlertBox {
  static void userBlockedAlert() {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                log("on invoked");
              },
              child: AlertDialog(
                backgroundColor: BColors.white,
                title: const Text('Account Blocked'),
                content: const Text(
                    'Your account is blocked by admin. Please contact admin to unblock your account'),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: AppDetails.phoneNumber,
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        CustomToast.errorToast(
                            text: 'Could not launch the dialer');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all()),
                      child: const Padding(
                        padding: EdgeInsets.all(7.0),
                        child: Text(
                          'Contact us',
                          style: TextStyle(color: BColors.black),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: BColors.darkblue,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Text(
                          'Try Again',
                          style: TextStyle(color: BColors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}
