import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';

abstract class ILabOrdersFacade {
  FutureResult<String> createLabOrder({required LabOrdersModel labOrdersModel});
}
