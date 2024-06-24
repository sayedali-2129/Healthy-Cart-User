import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';

abstract class IPharmacyOrderFacade {
  FutureResult<List<PharmacyOrderModel>> getPendingOrders({
    required String userId,
  });

  FutureResult<Unit> cancelPendingOrder(
      {required String orderProductId,});
}
