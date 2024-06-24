import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_booking_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IHospitalBookingFacade)
class IHospitalBookingImpl implements IHospitalBookingFacade {
  IHospitalBookingImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  FutureResult<String> createHospitalBooking(
      {required HospitalBookingModel hospitalBookingModel}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .add(hospitalBookingModel.toMap());
      return right('Booking Request Send Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
