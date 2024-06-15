import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ConfirmAlertBoxWidget {
  static void showAlertConfirmBox(
      {required BuildContext context,
      required VoidCallback confirmButtonTap,
      required String titleText,
      double titleSize = 15,
      required String subText}) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: 260,
          height: 300,
          child: AlertDialog(
            backgroundColor: BColors.white,
            title: Text(titleText,
                style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat')),
            content: Text(subText,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat')),
            actions: [
              TextButton(
                  onPressed: () {
                    EasyNavigation.pop(context: context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: BColors.darkblue),
                  )),
              ElevatedButton(
                onPressed: () {
                  EasyNavigation.pop(context: context);
                  confirmButtonTap.call();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: BColors.mainlightColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text('Yes',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: BColors.textWhite)),
              ),
            ],
          ),
        );
      },
    );
  }
}
