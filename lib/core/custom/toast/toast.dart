import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class CustomToast {
  // final BuildContext context;
  // static BuildContext? currentContext;
  // CustomToast(this.context) {
  //   currentContext = context;
  // }

  static void sucessToast({required String text}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: BColors.buttonLightColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void errorToast({required String text}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: BColors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
