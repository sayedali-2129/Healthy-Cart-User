import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

class RazorpayService {
  static final _firestore = FirebaseFirestore.instance;
  static bool _isLoading = false;
  static Future<void> pay({
    required num amount,
    required String rzpKey,
    required String razorpayKeySecret,
    required String appName,
    String? itemName,
    required RzpUserProfile userProfile,
    required Function(PaymentSuccessResponse response) success,
    required Function(PaymentFailureResponse response) failure,
  }) async {
    if (razorpayKeySecret.trim().isEmpty || rzpKey.trim().isEmpty) {
      CustomToast.errorToast(
          text: 'Razorpay Key Secret or Razorpay Key cannot be empty');
      return;
    }

    ///
    if (_isLoading) return;
    _isLoading = true;
    final orderId = await createRazorpayOrder(
      amount: amount,
      rzpKey: rzpKey,
      razorpayKeySecret: razorpayKeySecret,
    );
    if (orderId == null) return;

    ///
    final id = _firestore.collection('rzpayPaymentTransaction').doc().id;
    // set processing transaction
    await _createProcessingTransaction(
      orderId: orderId,
      amount: amount,
      appName: appName,
      rzpKey: rzpKey,
      transaction: id,
      userProfile: userProfile,
      itemName: itemName,
    );
    //
    final razorpay = Razorpay();
    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      (PaymentSuccessResponse response) {
        success.call(response);
        _updateSuccessTransaction(transaction: id);
        _isLoading = false;
      },
    );
    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      (PaymentFailureResponse response) {
        failure.call(response);
        _updateFailureTransaction(transaction: id);
        _isLoading = false;
      },
    );
    var options = {
      'id': id,
      'key': rzpKey,
      'amount': (amount * 100),
      'name': appName,
      'description': itemName,
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'name': userProfile.name,
        'contact': userProfile.phoneNumber,
        'email': userProfile.email,
      },
    };
    razorpay.open(options);
  }

  static Future<void> _createProcessingTransaction({
    required num amount,
    required String rzpKey,
    required String appName,
    String? itemName,
    required RzpUserProfile userProfile,
    required String transaction,
    required String orderId,
  }) async {
    _firestore.collection('rzpayPaymentTransaction').doc(transaction).set(
      {
        'status': 'processing',
        'gateway': 'razorpay',
        'amount': amount,
        'rzpKey': rzpKey,
        'appName': appName,
        'itemName': itemName,
        'user': userProfile.toMap(),
        'id': transaction,
        'createdAt': FieldValue.serverTimestamp(),
        'orderId': orderId,
      },
    );
  }

  static Future<void> _updateSuccessTransaction({
    required String transaction,
  }) async {
    _firestore.collection('rzpayPaymentTransaction').doc(transaction).update(
      {
        'status': 'success',
        'successTime': FieldValue.serverTimestamp(),
      },
    );
  }

  static Future<void> _updateFailureTransaction({
    required String transaction,
  }) async {
    _firestore.collection('rzpayPaymentTransaction').doc(transaction).update(
      {
        'status': 'failure',
        'failureTime': FieldValue.serverTimestamp(),
      },
    );
  }

  static Future<String?> createRazorpayOrder({
    required num amount,
    required String rzpKey,
    required String razorpayKeySecret,
  }) async {
    try {
      String receipt =
          'rcpt_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}_${const Uuid().v4().substring(0, 8)}';
      log('receipt $receipt');

      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$rzpKey:$razorpayKeySecret'))}';

      // Debugging log
      log('Authorization Header: $basicAuth');

      Map<String, dynamic> data = {
        "amount": (amount * 100),
        "currency": "INR",
        "receipt": receipt,
      };

      // Debugging log
      log('Request Data: $data');

      http.Response response = await http.post(
        Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Debugging log
      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var orderId = responseData['id'];
        return orderId;
      } else {
        CustomToast.errorToast(
            text: 'Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      CustomToast.errorToast(text: 'Error creating order: $e');
      log(e.toString());
    }
    return null;
  }
}

class RzpUserProfile {
  String? name;
  String? phoneNumber;
  String? email;
  String uid;
  RzpUserProfile({
    this.name,
    this.phoneNumber,
    this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'uid': uid,
    };
  }

  factory RzpUserProfile.fromMap(Map<String, dynamic> map) {
    return RzpUserProfile(
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      uid: map['uid'] as String,
    );
  }
}
