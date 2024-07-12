import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';

abstract class IHospitalBookingFacade {
  FutureResult<String> createHospitalBooking(
      {required HospitalBookingModel hospitalBookingModel});

  FutureResult<List<HospitalBookingModel>> getPendingOrders(
      {required String userId});
  Stream<Either<MainFailure, List<HospitalBookingModel>>> getAcceptedOrders(
      {required String userId});
  FutureResult<List<HospitalBookingModel>> getCancelledOrders(
      {required String userId});
  FutureResult<List<HospitalBookingModel>> getCompletedOrders(
      {required String userId});
  FutureResult<String> cancelOrder({required String orderId});
  FutureResult<String> acceptOrder(
      {required String orderId, required String paymentMethod});
  void clearCompletedOrderData();

  void clearCancelledData();
  ///////Location wise doctor fetching//////////////////
  FutureResult<List<DoctorModel>> fetchAllDoctorsCategoryWiseLocationBasedData({
    required PlaceMark placeMark,
    required String categoryId,
  }) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<Unit> fectchAllDoctorsCategoryWiseLocation(PlaceMark placeMark) {
    throw UnimplementedError('fecthUserLocaltion is not implemented');
  }

  void clearAllDoctorsCategoryWiseLocationData() {
    throw UnimplementedError('clearData is not implemented');
  }
}
