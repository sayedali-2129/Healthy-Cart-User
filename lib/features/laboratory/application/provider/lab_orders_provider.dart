import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_orders_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class LabOrdersProvider with ChangeNotifier {
  LabOrdersProvider(this.iLabOrdersFacade);
  final ILabOrdersFacade iLabOrdersFacade;

  bool isLoading = false;
  Set<String> labOrderIds = {};
  List<LabOrdersModel> approvedOrders = [];
  List<LabOrdersModel> pendingOrders = [];
  List<LabOrdersModel> cancelledOrders = [];
  List<LabOrdersModel> completedOrders = [];

  String? paymentType;

  /* ------------------------------ PAYMENT TYPE ------------------------------ */

  void setPaymentType(String? value) {
    paymentType = value;
    notifyListeners();
  }

/* -------------------------- GET LAB ORDERS STREAM ------------------------- */
  void getLabOrder({required String userId}) {
    isLoading = true;
    notifyListeners();

    iLabOrdersFacade.getLabOrders(userId: userId).listen(
      (event) {
        event.fold((err) {
          log(err.errMsg);
          isLoading = false;
          notifyListeners();
        }, (success) {
          // final uniquelists = success
          //     .where(
          //       (element) => !labOrderIds.contains(element.id),
          //     )
          //     .toList();
          // labOrderIds.addAll(uniquelists.map((orders) => orders.id!));
          // approvedOrders.addAll(uniquelists);

          // log(approvedOrders.length.toString());
          approvedOrders = success;
          isLoading = false;
          notifyListeners();
        });
      },
    );
  }

  /* --------------------------- GET PENDING ORDERS --------------------------- */
  Future<void> getPendingOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    final result = await iLabOrdersFacade.getPendingOrders(userId: userId);
    result.fold((err) {
      log('Error :: ${err.errMsg}');
    }, (success) {
      pendingOrders = success;
    });
    isLoading = false;
    notifyListeners();
  }

  /* ---------------------------- USER ACCEPT ORDER --------------------------- */
  Future<void> acceptOrder({required String orderId}) async {
    final result = await iLabOrdersFacade.acceptOrder(
        orderId: orderId, paymentMethod: paymentType!);
    result.fold((err) {
      CustomToast.errorToast(text: 'Failed to accept booking');
      log('Error :: ${err.errMsg}');
    }, (success) {
      CustomToast.sucessToast(text: success);
    });
  }

  /* ------------------------------ CANCEL ORDER ------------------------------ */
  Future<void> cancelOrder(
      {required String orderId, required int index}) async {
    final result = await iLabOrdersFacade.cancelOrder(orderId: orderId);
    result.fold((err) {
      CustomToast.errorToast(text: 'Failed to cancel booking');
      log(err.errMsg);
    }, (success) {
      pendingOrders.removeAt(index);
      CustomToast.sucessToast(text: success);
    });
    notifyListeners();
  }

/* --------------------- GET CANCELLED DATA LAZY LOADING -------------------- */
  Future<void> getCancelledOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    final result = await iLabOrdersFacade.getCancelledOrders(userId: userId);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      cancelledOrders.addAll(success);
    });
    isLoading = false;
    notifyListeners();
  }

  void clearCancelledData() {
    iLabOrdersFacade.clearCancelledData();
    cancelledOrders = [];
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

  /* -------------------------------------------------------------------------- */
  /* -------------------- GET COMPLETED ORDERS LAZY LOADING ------------------- */
  Future<void> getCompletedOrders({required String userId}) async {
    isLoading = true;
    notifyListeners();
    final result = await iLabOrdersFacade.getCompletedOrders(userId: userId);

    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      completedOrders.addAll(success);
    });
    isLoading = false;
    notifyListeners();
  }

  void clearCompletedOrderData() {
    iLabOrdersFacade.clearCompletedOrderData();
    completedOrders = [];
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

  /* ------------------------------ DOWNLOAD PDF ------------------------------ */

  /* ------------------------------ CALCULATIONS ------------------------------ */
  // num claculateTotalAmount(int index) {
  //   num totalAmount = 0;
  //   for (final item in approvedOrders) {
  //     totalAmount += item.selectedTest![index].offerPrice ??
  //         item.selectedTest![index].testPrice!;
  //   }

  //   return totalAmount;
  // }

  // num claculateTotalTestFee(int index) {
  //   num totalTestfee = 0;
  //   for (final item in approvedOrders) {
  //     totalTestfee += item.selectedTest![index].testPrice!;
  //   }

  //   return totalTestfee;
  // }

  // num claculateTotalOfferPrice(int index) {
  //   num totalOfferPrice = 0;
  //   for (final item in approvedOrders) {
  //     totalOfferPrice += item.selectedTest![index].offerPrice ?? 0;
  //   }

  //   return totalOfferPrice;
  // }

  // num totalDicount(int index) {
  //   return claculateTotalAmount(index) - claculateTotalTestFee(index);
  // }
  /* -------------------------------------------------------------------------- */
}
