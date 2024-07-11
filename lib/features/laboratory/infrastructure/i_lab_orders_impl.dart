import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/image_picker.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_orders_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILabOrdersFacade)
class ILabOrdersImpl implements ILabOrdersFacade {
  ILabOrdersImpl(this._firestore, this._imageService);
  final FirebaseFirestore _firestore;
  final ImageService _imageService;

  DocumentSnapshot<Map<String, dynamic>>? cancelledLastDoc;
  bool cancelledNoMoreData = false;
  DocumentSnapshot<Map<String, dynamic>>? completedLastDoc;
  bool completedNoMoreData = false;

  StreamSubscription? labOrderSubscription;

  StreamController<Either<MainFailure, List<LabOrdersModel>>>
      labOrderController =
      StreamController<Either<MainFailure, List<LabOrdersModel>>>.broadcast();

/* ---------------------------- CREATE LAB ORDER ---------------------------- */
  @override
  FutureResult<String> createLabOrder(
      {required LabOrdersModel labOrdersModel}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .add(labOrdersModel.toMap());
      return right('Order Request Send Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ---------------------------- PICK PRESCRIPTION --------------------------- */
  @override
  FutureResult<File> pickPrescription({required ImageSource source}) async {
    return await _imageService.getGalleryImage(imagesource: source);
  }

/* ---------------------------- SAVE PRESCRIPTION --------------------------- */
  @override
  FutureResult<String> uploadPrescription(File imageFile) async {
    return await _imageService.saveImage(
        folderName: 'lab_prescription', imageFile: imageFile);
  }

  /* ----------------------------- GET LAB ORDERS ----------------------------- */

  @override
  Stream<Either<MainFailure, List<LabOrdersModel>>> getLabOrders(
      {required String userId}) async* {
    try {
      labOrderSubscription = _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 1),
          ))
          .orderBy('acceptedAt', descending: true)
          .snapshots()
          .listen(
        (doc) {
          labOrderController.add(right(doc.docs
              .map((e) => LabOrdersModel.fromMap(e.data()).copyWith(id: e.id))
              .toList()));
        },
      );
    } catch (e) {
      labOrderController
          .add(left(MainFailure.generalException(errMsg: e.toString())));
    }
    yield* labOrderController.stream;
  }

/* ---------------------------- GET PENDIG ORDERS --------------------------- */
  @override
  FutureResult<List<LabOrdersModel>> getPendingOrders(
      {required String userId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 0)))
          .orderBy('orderAt', descending: true)
          .get();

      return right(responce.docs
          .map((e) => LabOrdersModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* -------------------------- GET CANCELLED ORDERS -------------------------- */

  @override
  FutureResult<List<LabOrdersModel>> getCancelledOrders(
      {required String userId}) async {
    if (cancelledNoMoreData) return right([]);
    try {
      Query query = _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 3)))
          .orderBy('rejectedAt', descending: true);
      if (cancelledLastDoc != null) {
        query = query.startAfterDocument(cancelledLastDoc!);
      }
      final snapshot = await query.limit(10).get();
      if (snapshot.docs.length < 10 || snapshot.docs.isEmpty) {
        cancelledNoMoreData = true;
      } else {
        cancelledLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      return right(snapshot.docs
          .map((e) => LabOrdersModel.fromMap(e.data() as Map<String, dynamic>)
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
  /* -------------------------------------------------------------------------- */

  /* -------------------------- GET COMPLETED ORDERS -------------------------- */
  @override
  FutureResult<List<LabOrdersModel>> getCompletedOrders(
      {required String userId}) async {
    if (completedNoMoreData) return right([]);
    try {
      Query query = _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 2)))
          .orderBy('completedAt', descending: true);
      if (completedLastDoc != null) {
        query = query.startAfterDocument(completedLastDoc!);
      }
      final snapshot = await query.limit(10).get();
      if (snapshot.docs.length < 10 || snapshot.docs.isEmpty) {
        completedNoMoreData = true;
      } else {
        completedLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }

      return right(snapshot.docs
          .map((e) => LabOrdersModel.fromMap(e.data() as Map<String, dynamic>)
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

  /* ---------------------------- UPDATE ORDER STATUS TO ON PROCESS -------------------------- */
/* -------------------------------------------------------------------------- */
  @override
  FutureResult<String> acceptOrder(
      {required String orderId, required String paymentMethod}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .doc(orderId)
          .update({
        'isUserAccepted': true,
        'paymentMethod': paymentMethod,
        'paymentStatus': 1
      });
      return right('Booking Accepted Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* -------------------------- CANCEL ORDER BY USER -------------------------- */
  @override
  FutureResult<String> cancelOrder(
      {required String orderId, String? rejectReason}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .doc(orderId)
          .update({
        'orderStatus': 3,
        'rejectedAt': Timestamp.now(),
        'isRejectedByUser': true,
        'rejectReason': rejectReason
      });
      return right('Booking Cancelled Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
