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

  void getLabOrder() {
    isLoading = true;
    notifyListeners();

    iLabOrdersFacade.getLabOrders().listen(
      (event) {
        event.fold((err) {
          CustomToast.errorToast(text: err.errMsg);
          isLoading = false;
          notifyListeners();
        }, (success) {
          final uniquelists = success
              .where(
                (element) => !labOrderIds.contains(element.id),
              )
              .toList();
          labOrderIds.addAll(uniquelists.map((orders) => orders.id!));
          ordersList.addAll(uniquelists);

          log(ordersList.length.toString());
          isLoading = false;
          notifyListeners();
        });
      },
    );
  }
}
