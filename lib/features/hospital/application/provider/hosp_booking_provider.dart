import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_booking_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HospitalBookingProivder extends ChangeNotifier {
  HospitalBookingProivder(this.iHospitalBookingFacade);
  final IHospitalBookingFacade iHospitalBookingFacade;

  bool isLoading = false;

  /* ------------------------------ CANCEL ORDER ------------------------------ */
  Future<void> cancelOrder({
    required String orderId,
    required int index,
    // required String fcmtoken,
    // required userName
  }) async {
    final result = await iHospitalBookingFacade.cancelOrder(orderId: orderId);
    result.fold((err) {
      CustomToast.errorToast(text: 'Failed to cancel booking');
      log(err.errMsg);
    }, (success) {
      pendingList.removeAt(index);
      // sendFcmMessage(
      //     token: fcmtoken,
      //     body: 'A Booking is cancelled by $userName, Booking ID : $orderId',
      //     title: 'Booking Cancelled!!');
      CustomToast.sucessToast(text: success);
    });
    notifyListeners();
  }

  /* --------------------------- GET PENDING ORDERS --------------------------- */
  List<HospitalBookingModel> pendingList = [];
  Future<void> getPendingOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iHospitalBookingFacade.getPendingOrders(userId: userId);
    result.fold((err) {
      log('Error :: ${err.errMsg}');
    }, (success) {
      log("SUCCES:${success.length}");
      pendingList = success;
    });
    isLoading = false;
    notifyListeners();
  }

/* --------------------- GET CANCELLED DATA LAZY LOADING -------------------- */
  List<HospitalBookingModel> cancelledHospBooking = [];

  Future<void> getCancelledOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iHospitalBookingFacade.getCancelledOrders(userId: userId);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      cancelledHospBooking.addAll(success);
    });
    isLoading = false;
    notifyListeners();
  }

  void clearCancelledData() {
    iHospitalBookingFacade.clearCancelledData();
    cancelledHospBooking = [];
    notifyListeners();
  }

  void cancelledInit(
      {required ScrollController scrollController, required String userId}) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            isLoading == false) {
          getCancelledOrders(userId: userId);
        }
      },
    );
  }
}
