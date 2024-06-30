import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';

abstract class IPharmacyOrderFacade {
  FutureResult<List<PharmacyOrderModel>> getPendingOrders({
    required String userId,
  });

  FutureResult<Unit> cancelOrder( {required String orderId, required PharmacyOrderModel orderData });
  Stream<Either<MainFailure, List<PharmacyOrderModel>>> pharmacyApprovedOrderData({
    required String userId,
  });
  Future<void> cancelStream();
    FutureResult<PharmacyOrderModel> updateProductApprovedDetails(
      {required String orderId, required PharmacyOrderModel orderProducts,});
   FutureResult<List<PharmacyOrderModel>> getCompletedOrderDetails({
    required String userId,
  }); 
 FutureResult<List<PharmacyOrderModel>> getCancelledOrderDetails({
    required String userId,
  });
void clearFetchData();
  FutureResult<PharmacyOrderModel> updateOrderCompleteDetails(
      {required String orderId, required PharmacyOrderModel orderProducts,});

}
