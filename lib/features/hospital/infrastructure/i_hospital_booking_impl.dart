import 'dart:async';

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

  @override
  FutureResult<List<HospitalBookingModel>> getPendingOrders(
      {required String userId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 0)))
          .orderBy('bookedAt', descending: true)
          .get();

      return right(responce.docs
          .map((e) => HospitalBookingModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ---------------------- GET APPROVED HOSPITAL BOOKING --------------------- */
  StreamSubscription? hospOrderSubscription;

  StreamController<Either<MainFailure, List<HospitalBookingModel>>>
      hospOrderController = StreamController<
          Either<MainFailure, List<HospitalBookingModel>>>.broadcast();
  @override
  Stream<Either<MainFailure, List<HospitalBookingModel>>> getAcceptedOrders(
      {required String userId}) async* {
    try {
      hospOrderSubscription = _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 1),
          ))
          .orderBy('acceptedAt', descending: true)
          .snapshots()
          .listen(
        (doc) {
          hospOrderController.add(right(doc.docs
              .map((e) =>
                  HospitalBookingModel.fromMap(e.data()).copyWith(id: e.id))
              .toList()));
        },
      );
    } catch (e) {
      hospOrderController
          .add(left(MainFailure.generalException(errMsg: e.toString())));
    }
    yield* hospOrderController.stream;
  }

  /* -------------------------- GET CANCELLED ORDERS -------------------------- */
  DocumentSnapshot<Map<String, dynamic>>? cancelledLastDoc;
  bool cancelledNoMoreData = false;
  @override
  FutureResult<List<HospitalBookingModel>> getCancelledOrders(
      {required String userId}) async {
    if (cancelledNoMoreData) return right([]);
    int limit = cancelledLastDoc == null ? 10 : 5;
    try {
      Query query = _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 3)))
          .orderBy('rejectedAt', descending: true);
      if (cancelledLastDoc != null) {
        query = query.startAfterDocument(cancelledLastDoc!);
      }
      final snapshot = await query.limit(limit).get();
      if (snapshot.docs.length < limit || snapshot.docs.isEmpty) {
        cancelledNoMoreData = true;
      } else {
        cancelledLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      return right(snapshot.docs
          .map((e) =>
              HospitalBookingModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearCancelledData() {
    cancelledNoMoreData = false;
    cancelledLastDoc = null;
  }

  /* -------------------------- CANCEL ORDER BY USER -------------------------- */
  @override
  FutureResult<String> cancelOrder({required String orderId}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .doc(orderId)
          .update({'orderStatus': 3, 'rejectedAt': Timestamp.now()});
      return right('Booking Cancelled Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ---------------------------- UPDATE ORDER STATUS TO ON PROCESS -------------------------- */
/* -------------------------------------------------------------------------- */
  @override
  FutureResult<String> acceptOrder(
      {required String orderId, required String paymentMethod}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .doc(orderId)
          .update({'isUserAccepted': true, 'paymentMethod': paymentMethod});
      return right('Booking Accepted Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* -------------------------- GET COMPLETED ORDERS -------------------------- */
  DocumentSnapshot<Map<String, dynamic>>? completedLastDoc;
  bool completedNoMoreData = false;

  @override
  FutureResult<List<HospitalBookingModel>> getCompletedOrders(
      {required String userId}) async {
    if (completedNoMoreData) return right([]);

    int limit = completedLastDoc == null ? 8 : 4;
    try {
      Query query = _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 2)))
          .orderBy('completedAt', descending: true);
      if (completedLastDoc != null) {
        query = query.startAfterDocument(completedLastDoc!);
      }
      final snapshot = await query.limit(limit).get();
      if (snapshot.docs.length < limit || snapshot.docs.isEmpty) {
        completedNoMoreData = true;
      } else {
        completedLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }

      return right(snapshot.docs
          .map((e) =>
              HospitalBookingModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearCompletedOrderData() {
    completedNoMoreData = false;
    completedLastDoc = null;
  }
}
