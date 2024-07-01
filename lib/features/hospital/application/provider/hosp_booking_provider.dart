import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/send_fcm_message.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_booking_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HospitalBookingProivder extends ChangeNotifier {
  HospitalBookingProivder(this.iHospitalBookingFacade);
  final IHospitalBookingFacade iHospitalBookingFacade;

  bool isLoading = false;
  String? hospitalpPaymentType;

  /* ------------------------------ PAYMENT TYPE ------------------------------ */

  void setPaymentType(String? value) {
    hospitalpPaymentType = value;
    notifyListeners();
  }

  /* -------------------------- GET APPROVED BOOKINGS ------------------------- */
  List<HospitalBookingModel> approvedBookings = [];
  void getAcceptedOrders({required String userId}) {
    isLoading = true;
    notifyListeners();

    iHospitalBookingFacade.getAcceptedOrders(userId: userId).listen(
      (event) {
        event.fold((err) {
          log(err.errMsg);
          isLoading = false;
          notifyListeners();
        }, (success) {
          approvedBookings = success;
          isLoading = false;
          notifyListeners();
        });
      },
    );
    notifyListeners();
  }

  /* ------------------------------ CANCEL ORDER ------------------------------ */
  Future<void> cancelOrder(
      {required String orderId,
      int? index,
      required bool fromPending,
      required String fcmtoken,
      required userName}) async {
    final result = await iHospitalBookingFacade.cancelOrder(orderId: orderId);
    result.fold((err) {
      CustomToast.errorToast(text: 'Failed to cancel booking');
      log(err.errMsg);
    }, (success) {
      if (fromPending == true) {
        pendingList.removeAt(index!);
      }
      sendFcmMessage(
          token: fcmtoken,
          body: 'A Booking is cancelled by $userName, Booking ID : $orderId',
          title: 'Booking Cancelled!!');
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

  /* -------------------- GET COMPLETED ORDERS LAZY LOADING ------------------- */
  List<HospitalBookingModel> completedBookings = [];
  Future<void> getCompletedOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iHospitalBookingFacade.getCompletedOrders(userId: userId);

    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      completedBookings.addAll(success);
    });
    isLoading = false;
    notifyListeners();
  }

  void clearCompletedOrderData() {
    iHospitalBookingFacade.clearCompletedOrderData();
    completedBookings = [];
    notifyListeners();
  }

  void completedOrdersInit(
      {required ScrollController scrollController, required String userId}) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            isLoading == false) {
          getCompletedOrders(userId: userId);
        }
      },
    );
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

  /* ---------------------------- USER ACCEPT ORDER --------------------------- */
  Future<void> acceptOrder(
      {required String orderId,
      required String fcmtoken,
      required String userName}) async {
    final result = await iHospitalBookingFacade.acceptOrder(
        orderId: orderId, paymentMethod: hospitalpPaymentType!);
    result.fold((err) {
      CustomToast.errorToast(text: 'Failed to accept booking');
      log('Error :: ${err.errMsg}');
    }, (success) {
      CustomToast.sucessToast(text: success);
      sendFcmMessage(
          token: fcmtoken,
          body:
              '$userName accepted an order, Please check the status. Booking ID : $orderId',
          title: 'User Accepted An order');
      log(fcmtoken);
    });
  }
}
