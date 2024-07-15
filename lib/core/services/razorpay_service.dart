import 'package:get/get.dart';
import 'package:healthy_cart_user/core/custom/payment_status_screen.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final _razorpay = Razorpay();

  void openRazorpay(
      {required amount,
      required key,
      required orgName,
      required userPhoneNumber,
      required userEmail,
      required PaymentSuccessCallback onSuccess}) {
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
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (response) => handlePaymentSuccess(response, onSuccess));
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentSuccess(
      PaymentSuccessResponse response, PaymentSuccessCallback onSuccess) {
    CustomToast.sucessToast(
        text: 'Payment Successful ORDER ID: ${response.paymentId!}');
    onSuccess(response.paymentId!);
    Get.to(() =>
        PaymentStatusScreen(isErrorPage: false, bookingId: response.paymentId));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.to(() =>
        PaymentStatusScreen(isErrorPage: true, bookingId: response.message));

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
