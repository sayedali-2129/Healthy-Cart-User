import 'package:flutter/material.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_orders_facade.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LabOrdersProvider with ChangeNotifier {
  LabOrdersProvider(this._labOrdersFacade);
  final ILabOrdersFacade _labOrdersFacade;
}
