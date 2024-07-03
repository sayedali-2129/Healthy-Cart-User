import 'dart:developer';

import 'package:get/get.dart';
import 'package:healthy_cart_user/core/custom/payment_status_screen.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final _razorpay = Razorpay();

  void openRazorpay({
    required amount,
    required key,
    required orgName,
    required userPhoneNumber,
    required userEmail,
  }) {
    amount = amount * 100;

    var options = {
      'key': key,
      'amount': amount,
      'name': orgName,
      'retry': {'enabled': true, 'max_count': 1},
      'prefill': {'contact': userPhoneNumber, 'email': userEmail},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    try {
      log('$options');
      _razorpay.open(options);
    } catch (e) {
      log(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    CustomToast.sucessToast(
        text: 'Payment Successful ORDER ID: ${response.paymentId!}');
    Get.to(
        PaymentStatusScreen(isErrorPage: false, bookingId: response.orderId!));
    // EasyNavigation.push(
    //     context: navigatorKey.currentContext!,
    //     page: PaymentStatusScreen(
    //       bookingId: response.orderId!,
    //       isErrorPage: false,
    //     ));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // EasyNavigation.pushReplacement(
    //     context: navigatorKey.currentContext!,
    //     page: PaymentStatusScreen(
    //       reason: response.message!,
    //       isErrorPage: true,
    //     ));
    Get.to(
        PaymentStatusScreen(isErrorPage: true, bookingId: response.message!));
    CustomToast.errorToast(
        text: 'Payment Failed ORDER ID: ${response.message!}');
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    CustomToast.sucessToast(
        text: 'Payment Successful ORDER ID: ${response.walletName}');
    EasyNavigation.push(
        context: navigatorKey.currentContext!,
        page: PaymentStatusScreen(
          bookingId: response.walletName!,
          isErrorPage: false,
        ));
  }

  void dispose() {
    _razorpay.clear();
  }
}
