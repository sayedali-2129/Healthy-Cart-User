import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';

abstract class IHospitalBookingFacade {
  FutureResult<String> createHospitalBooking(
      {required HospitalBookingModel hospitalBookingModel});
}
