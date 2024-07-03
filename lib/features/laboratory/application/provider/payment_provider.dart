import 'package:flutter/foundation.dart';
import 'package:healthy_cart_user/core/services/razorpay_service.dart';

class PaymentProvider extends ChangeNotifier {
  final RazorpayService razorpayService = RazorpayService();
}
