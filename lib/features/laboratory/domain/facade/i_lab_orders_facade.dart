import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class ILabOrdersFacade {
  FutureResult<String> createLabOrder({required LabOrdersModel labOrdersModel});
  FutureResult<File> pickPrescription({required ImageSource source});
  FutureResult<String> uploadPrescription(File imageFile);
  Stream<Either<MainFailure, List<LabOrdersModel>>> getLabOrders(
      {required String userId});
  FutureResult<String> acceptOrder(
      {required String orderId, required String paymentMethod});
  FutureResult<String> cancelOrder({required String orderId});
  FutureResult<List<LabOrdersModel>> getPendingOrders({required String userId});
  FutureResult<List<LabOrdersModel>> getCancelledOrders(
      {required String userId});
  FutureResult<List<LabOrdersModel>> getCompletedOrders(
      {required String userId});
  void clearCancelledData();
  void clearCompletedOrderData();
}
