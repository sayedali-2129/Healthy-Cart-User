import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_order_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPharmacyOrderFacade)
class IPharmacyOrdersImpl implements IPharmacyOrderFacade {
  IPharmacyOrdersImpl(
    this._firebaseFirestore,
  );
  final FirebaseFirestore _firebaseFirestore;
  late StreamSubscription _streamSubscription;
  @override
  FutureResult<List<PharmacyOrderModel>> getPendingOrders({
    required String userId,
  }) async {
    try {
      final responce = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('createdAt', descending: true)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 0),
          ))
          .get();

      return right(responce.docs
          .map((e) => PharmacyOrderModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<Unit> cancelOrder(
      {required String orderId, required PharmacyOrderModel orderData}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderId)
          .update(orderData.toEditMap());

      return right(unit);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* -------------------------------------------------------------------------- */
  /* ------------------------- APPROVED ORDER GET AND UPDATE ------------------------ */
  @override
  Stream<Either<MainFailure, List<PharmacyOrderModel>>>
      getPharmacyApprovedOrderData({
    required String userId,
  }) async* {
    final StreamController<Either<MainFailure, List<PharmacyOrderModel>>>
        onProcessController =
        StreamController<Either<MainFailure, List<PharmacyOrderModel>>>();
    try {
      _streamSubscription = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('acceptedAt', descending: true)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 1),
          ))
          .snapshots()
          .listen(
        (docsList) {
          final newOrderList = docsList.docs
              .map((e) =>
                  PharmacyOrderModel.fromMap(e.data()).copyWith(id: e.id))
              .toList();
          onProcessController.add(right(newOrderList));
        },
      );
    } on FirebaseException catch (e) {
      onProcessController
          .add(left(MainFailure.firebaseException(errMsg: e.code)));
    } catch (e) {
      onProcessController
          .add(left(MainFailure.generalException(errMsg: e.toString())));
    }
    yield* onProcessController.stream;
  }

  @override
  Future<void> cancelStream() async {
    await _streamSubscription.cancel();
  }

  /* ------------------------- UPDATE ------------------------ */
  @override
  FutureResult<PharmacyOrderModel> updateProductApprovedDetails(
      {required String orderId,
      required PharmacyOrderModel orderProducts}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderId)
          .update(orderProducts.toEditMap());

      return right(orderProducts.copyWith(id: orderId));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* -------------------------------------------------------------------------- */
  /* ---------------------------- GET COMPLETED ORDER---------------------------- */
  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  @override
  FutureResult<List<PharmacyOrderModel>> getCompletedOrderDetails({
    required String userId,
  }) async {
    try {
      final limit = lastDoc == null ? 6 : 3;
      if (noMoreData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('completedAt', descending: true)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 2),
          ));

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }
      final snapshots = await query.limit(limit).get();
      if (snapshots.docs.length < limit || snapshots.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyOrderModel> productList = snapshots.docs
          .map((e) =>
              PharmacyOrderModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearFetchData() {
    noMoreData = false;
    lastDoc = null;
  }

/* ------------------------- CANCELLED ORDER SECTION ------------------------ */
  @override
  FutureResult<List<PharmacyOrderModel>> getCancelledOrderDetails({
    required String userId,
  }) async {
    try {
      final limit = lastDoc == null ? 6 : 3;
      if (noMoreData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('rejectedAt', descending: true)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 3),
          ));

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }
      final snapshots = await query.limit(limit).get();
      if (snapshots.docs.length < limit || snapshots.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyOrderModel> productList = snapshots.docs
          .map((e) =>
              PharmacyOrderModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<PharmacyOrderModel> updateOrderCompleteDetails(
      {required String orderId,
      required PharmacyOrderModel orderProducts}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderId)
          .update(orderProducts.toMap());

      return right(orderProducts.copyWith(id: orderId));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* -------------------------- GET SINGLR ACCEPT DOC ------------------------- */
  @override
  FutureResult<PharmacyOrderModel> getSingleOrderDoc(
      {required String userId}) async {
    try {
      final responce = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .where(Filter.and(
              Filter('userId', isEqualTo: userId),
              Filter('isUserAccepted', isEqualTo: false),
              Filter('orderStatus', isEqualTo: 1)))
          .limit(1)
          .get();

      return right(PharmacyOrderModel.fromMap(responce.docs.single.data()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
