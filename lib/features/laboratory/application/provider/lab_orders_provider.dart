import 'dart:developer';

import 'package:flutter/material.dart';
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
  List<LabOrdersModel> ordersList = [];

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
          // ordersList.addAll(uniquelists);

          // log(ordersList.length.toString());
          ordersList = success;
          isLoading = false;
          notifyListeners();
        });
      },
    );
  }

  /* ------------------------------ CANCEL ORDER ------------------------------ */
  Future<void> cancelOrder({required String orderId}) async {
    final result = await iLabOrdersFacade.cancelOrder(orderId: orderId);
    result.fold((err) {
      CustomToast.errorToast(text: 'Failed to cancel order');
      log(err.errMsg);
    }, (success) {
      CustomToast.sucessToast(text: success);
    });
    notifyListeners();
  }

  /* ------------------------------ CALCULATIONS ------------------------------ */
  // num claculateTotalAmount(int index) {
  //   num totalAmount = 0;
  //   for (final item in ordersList) {
  //     totalAmount += item.selectedTest![index].offerPrice ??
  //         item.selectedTest![index].testPrice!;
  //   }

  //   return totalAmount;
  // }

  // num claculateTotalTestFee(int index) {
  //   num totalTestfee = 0;
  //   for (final item in ordersList) {
  //     totalTestfee += item.selectedTest![index].testPrice!;
  //   }

  //   return totalTestfee;
  // }

  // num claculateTotalOfferPrice(int index) {
  //   num totalOfferPrice = 0;
  //   for (final item in ordersList) {
  //     totalOfferPrice += item.selectedTest![index].offerPrice ?? 0;
  //   }

  //   return totalOfferPrice;
  // }

  // num totalDicount(int index) {
  //   return claculateTotalAmount(index) - claculateTotalTestFee(index);
  // }
  /* -------------------------------------------------------------------------- */
}
