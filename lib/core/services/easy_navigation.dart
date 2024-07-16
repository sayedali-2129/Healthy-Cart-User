import 'package:flutter/material.dart';
import 'package:healthy_cart_user/main.dart';
import 'package:page_transition/page_transition.dart';

class EasyNavigation {
  static Future<void> push({
    required BuildContext context,
    required Widget page,
  
    PageTransitionType type = PageTransitionType.fade,
  }) async {
    await Navigator.push(
     navigatorKey.currentState?.context?? context,
      PageTransition(
        child: page,
        type: type,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  static Future<void> pushReplacement({
    required BuildContext context,
    required Widget page,
    PageTransitionType type = PageTransitionType.fade,
 
  }) async {
    await Navigator.pushReplacement(
      navigatorKey.currentState?.context??context,
      PageTransition(
        child: page,
        type: type,
        duration: const Duration(milliseconds:300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  static Future<void> pop({
    required BuildContext context,
  }) async {
    Navigator.of(navigatorKey.currentState?.context ?? context).pop();
  }

  static Future<void> pushAndRemoveUntil({
    required BuildContext context,
    required Widget page,
    PageTransitionType type = PageTransitionType.fade,
  }) async {
    await Navigator.pushAndRemoveUntil(
      navigatorKey.currentState?.context?? context,
      PageTransition(
        child: page,
        type: type,
        duration:const  Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
