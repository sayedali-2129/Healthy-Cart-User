import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_orders_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILabOrdersFacade)
class ILabOrdersImpl implements ILabOrdersFacade {
  ILabOrdersImpl(this._firestore);
  final FirebaseFirestore _firestore;

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
}
