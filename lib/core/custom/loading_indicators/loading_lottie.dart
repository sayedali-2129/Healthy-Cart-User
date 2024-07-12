import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';

class LoadingLottie {
  static showLoading({required BuildContext context, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              contentPadding: const EdgeInsets.only(bottom: 16),
              backgroundColor: Colors.white70,
              surfaceTintColor: Colors.transparent,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(BLottie.mainLoadingLottie,
                      fit: BoxFit.fill, height: 120, width: 120),
                  Text(
                    text,
                    style:
                        TextStyle(color: BColors.backgroundRoundContainerColor,fontWeight: FontWeight.w600,),
                  )
                ],
              ),
            ),
          );
        });
  }
}
