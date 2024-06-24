import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_order_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class PharmacyOrderProvider extends ChangeNotifier {
  PharmacyOrderProvider(this._iPharmacyOrderFacade);
  final IPharmacyOrderFacade _iPharmacyOrderFacade;
  bool isLoading = false;
  List<PharmacyOrderModel> pendingOrders = [];

  /* ------------------------ PENDING ORDERS ------------------------ */
  Future<void> getPendingOrders({
    required String userId,
  }) async {
    isLoading = true;
    notifyListeners();
    final result = await _iPharmacyOrderFacade.getPendingOrders(
      userId: userId,
    );
    result.fold((err) {
      log('Error :: ${err.errMsg}');
    }, (success) {
      pendingOrders = success;
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> cancelPendingOrder({
    required String orderProductId,
    required int index,
  }) async {
    isLoading = true;
    notifyListeners();
    final result = await _iPharmacyOrderFacade.cancelPendingOrder(
      orderProductId: orderProductId,
    );
    result.fold((err) {
      CustomToast.errorToast(text: "Couldn't able to cancel the order.");
      log('Error :: ${err.errMsg}');
    }, (success) {
      pendingOrders.removeAt(index);
      CustomToast.sucessToast(text: "Order is cancelled.");
    });
    isLoading = false;
    notifyListeners();
  }
}
