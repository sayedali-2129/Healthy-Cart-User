import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/core/services/send_fcm_message.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_order_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class PharmacyOrderProvider extends ChangeNotifier {
  PharmacyOrderProvider(this._iPharmacyOrderFacade);
  final IPharmacyOrderFacade _iPharmacyOrderFacade;
  bool fetchLoading = false;
  String? userId;
  final rejectionReasonController = TextEditingController();
  List<PharmacyOrderModel> pendingOrders = [];
  List<PharmacyOrderModel> approvedOrderList = [];
  List<PharmacyOrderModel> completedOrderList = [];
  List<PharmacyOrderModel> cancelledOrderList = [];

  /* ------------------------ PENDING ORDERS ------------------------ */
  void setUserId(String id) {
    userId = id;
  }

  Future<void> getPendingOrders() async {
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyOrderFacade.getPendingOrders(
      userId: userId ?? '',
    );
    result.fold((err) {
      log('Error :: ${err.errMsg}');
    }, (success) {
      pendingOrders = success;
    });
    fetchLoading = false;
    notifyListeners();
  }

  Future<void> cancelPendingOrder({
    required PharmacyOrderModel orderData,
    required int index,
  }) async {
    fetchLoading = true;
    notifyListeners();
    final data = orderData.copyWith(
        rejectReason: rejectionReasonController.text,
        isRejectedByUser: true,
        rejectedAt: Timestamp.now(),
        orderStatus: 3);
    final result = await _iPharmacyOrderFacade.cancelOrder(
      orderData: data,
      orderId: orderData.id ?? '',
    );
    result.fold((err) {
      CustomToast.errorToast(text: "Couldn't able to cancel the order.");
      log('Error :: ${err.errMsg}');
    }, (success) {
      pendingOrders.removeAt(index);
      CustomToast.sucessToast(text: "Order is cancelled.");
    });
    fetchLoading = false;
    notifyListeners();
  }

/* ----------------------------- DATE CONVERTOR ----------------------------- */
  String dateFromTimeStamp(Timestamp createdAt) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(createdAt.millisecondsSinceEpoch);
    return DateFormat('dd/MM/yyyy').format(date);
  }

/* -------------------------------------------------------------------------- */
/* ------------------------------ DELIVERY  AND PAYMENT TYPE ----------------------------- */
  String deliveryType(String delivery) {
    if (delivery == "Home") {
      return 'Home Delivery';
    } else {
      return 'Pick-Up at pharmacy';
    }
  }

  String paymentType(String paymentType) {
    if (paymentType == "COD") {
      return 'Cash on delivery';
    } else if (paymentType == "Online") {
      return 'Online';
    } else {
      return 'Pending';
    }
  }

  String? selectedPaymentRadio;

  void setSelectedRadio(String? value) {
    selectedPaymentRadio = value;
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */
  /* ------------------------------ LAUNCH DIALER ----------------------------- */
  Future<void> lauchDialer({required String phoneNumber}) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomToast.errorToast(text: 'Could not launch the dialer');
    }
  }

  /* ------------------------ PRODUCT ON PROCESS ORDER STREAM SECTION ----------------------- */

  Future<void> cancelStream() async {
    await _iPharmacyOrderFacade.cancelStream();
  }

  void getpharmacyApprovedOrderData() {
    fetchLoading = true;
    notifyListeners();
    _iPharmacyOrderFacade
        .pharmacyApprovedOrderData(userId: userId ?? '')
        .listen((event) {
      event.fold(
        (err) {
          CustomToast.errorToast(text: err.errMsg);
          fetchLoading = false;
          notifyListeners();
        },
        (approvedOrders) {
          approvedOrderList = approvedOrders;
          fetchLoading = false;
          notifyListeners();
        },
      );
    });

    notifyListeners();
  }

/* -----------------------------GET COMPLETED ORDER ---------------------------- */

  Future<void> getCompletedOrderDetails() async {
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyOrderFacade.getCompletedOrderDetails(
      userId: userId ?? '',
    );
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to get completed orders");
    }, (completedOrders) {
      log(completedOrders.length.toString());
      completedOrderList
          .addAll(completedOrders); //// here we are assigning the doctor
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearCompletedOrderFetchData() {
    completedOrderList.clear();
    _iPharmacyOrderFacade.clearFetchData();
  }

/* ------------------------- CANCELLED ORDER SECTION ------------------------ */
  Future<void> getCancelledOrderDetails() async {
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyOrderFacade.getCancelledOrderDetails(
      userId: userId ?? '',
    );
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to get completed orders");
    }, (cancelledOrders) {
      log(cancelledOrders.length.toString());
      cancelledOrderList
          .addAll(cancelledOrders); //// here we are assigning the doctor
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearCancelledOrderFetchData() {
    cancelledOrderList.clear();
    _iPharmacyOrderFacade.clearFetchData();
  }
  /* ----------------- UPDATE ACCORDING TO THE COMPLETE ORDER ----------------- */

  Future<void> updateOrderCompleteDetails({
    required PharmacyOrderModel productData,
    required BuildContext context,
  }) async {
    log('Data payment $selectedPaymentRadio');
    final data = productData.copyWith(
      isUserAccepted: true,
      paymentType: selectedPaymentRadio,
      paymentStatus: (selectedPaymentRadio == 'COD') ? 0 : 1,
      isPaymentRecieved: (selectedPaymentRadio == 'COD') ? false : true,
    );
    final result = await _iPharmacyOrderFacade.updateOrderCompleteDetails(
      orderId: productData.id ?? '',
      orderProducts: data,
    );
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
        EasyNavigation.pop(context: context);
        notifyListeners();
      },
      (orderProduct) {
        log('FCM ::::: ${orderProduct.pharmacyDetails?.fcmToken}');
        sendFcmMessage(
            token: orderProduct.pharmacyDetails?.fcmToken ?? '',
            body:
                '${orderProduct.userDetails?.userName ?? 'Customer'} has accepted and made payment of order with order ID - ${orderProduct.id}',
            title: 'New Order Placed!!!');

        notifyListeners();
      },
    );
  }

  /* ------------------------ CANCEL PHARMACY APPROVED ------------------------ */

  Future<void> cancelPharmacyApprovedOrder({
    required PharmacyOrderModel orderData,
  }) async {
    fetchLoading = true;
    notifyListeners();
    final data = orderData.copyWith(
        rejectReason: rejectionReasonController.text,
        isRejectedByUser: true,
        rejectedAt: Timestamp.now(),
        orderStatus: 3);
    final result = await _iPharmacyOrderFacade.cancelOrder(
      orderData: data,
      orderId: orderData.id ?? '',
    );
    result.fold((err) {
      CustomToast.errorToast(text: "Couldn't able to cancel the order.");
      log('Error :: ${err.errMsg}');
    }, (success) {
      CustomToast.sucessToast(text: "Order is cancelled.");
    });
    fetchLoading = false;
    notifyListeners();
  }
}
