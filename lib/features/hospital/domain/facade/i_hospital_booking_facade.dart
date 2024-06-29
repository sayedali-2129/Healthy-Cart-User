import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';

abstract class IHospitalBookingFacade {
  FutureResult<String> createHospitalBooking(
      {required HospitalBookingModel hospitalBookingModel});

  FutureResult<List<HospitalBookingModel>> getPendingOrders(
      {required String userId});
  Stream<Either<MainFailure, List<HospitalBookingModel>>> getAcceptedOrders(
      {required String userId});
  FutureResult<List<HospitalBookingModel>> getCancelledOrders(
      {required String userId});
  FutureResult<String> cancelOrder({required String orderId});

  void clearCancelledData();
}
