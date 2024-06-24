import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_order_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:injectable/injectable.dart';
@LazySingleton(as: IPharmacyOrderFacade)
class IPharmacyOrdersImpl implements IPharmacyOrderFacade{
  IPharmacyOrdersImpl(this._firebaseFirestore,);
  final FirebaseFirestore _firebaseFirestore;

  @override
  FutureResult<List<PharmacyOrderModel>> getPendingOrders({required String userId,}) async{
    try {
      final responce = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder).orderBy('createdAt', descending: true)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 0), ))      
          .get();

      return right(responce.docs
          .map((e) => PharmacyOrderModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
    @override
  FutureResult<Unit> cancelPendingOrder(
      {required String orderProductId,}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderProductId)
          .update({'orderStatus': 3});

      return right(unit);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

}