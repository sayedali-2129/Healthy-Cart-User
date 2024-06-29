import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/main.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';

// class CustomToast {
//   // final BuildContext context;
//   // static BuildContext? currentContext;
//   // CustomToast(this.context) {
//   //   currentContext = context;
//   // }

//   static void sucessToast({required String text}) {
//     Fluttertoast.showToast(
//         msg: text,
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 2,
//         backgroundColor: BColors.buttonLightColor,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   static void errorToast({required String text}) {
//     Fluttertoast.showToast(
//         msg: text,
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 2,
//         backgroundColor: BColors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }
// }

class CustomToast {
  // static BuildContext? currentContext;
  // final BuildContext context;

  // CustomToast({required this.context}) {
  //   currentContext = context;
  // }

  static void sucessToast({required String text}) {
    FToast ftoast = FToast();
    ftoast.init(navigatorKey.currentContext!);

    Widget toast = FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: Container(
        // width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green[500],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(BLottie.successToastLottie, height: 30, width: 30),
            const Gap(10),
            //message
            Flexible(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: BColors.white, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
    ftoast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static void errorToast({required String text}) {
    FToast ftoast = FToast();
    ftoast.init(navigatorKey.currentContext!);

    Widget toast = FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: Container(
        // width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: Colors.red[600],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(BLottie.errorToastLottie, height: 30, width: 30),
            const Gap(10),
            //message
            Flexible(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: BColors.white, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );

    ftoast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 1500),
    );
  }

  static void infoToast({required String text}) {
    FToast ftoast = FToast();
    ftoast.init(navigatorKey.currentContext!);

    Widget toast = FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: Container(
        // width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: const Color(0xff399FFF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(BLottie.infoToastLottie, height: 30, width: 30),
            const Gap(10),
            //message
            Flexible(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: BColors.white, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );

    ftoast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
