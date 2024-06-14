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
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILabOrdersFacade)
class ILabOrdersImpl implements ILabOrdersFacade {
  ILabOrdersImpl(this._firestore, this._imageService);
  final FirebaseFirestore _firestore;
  final ImageService _imageService;

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
  FutureResult<File> pickPrescription() async {
    return await _imageService.getGalleryImage();
  }

/* ---------------------------- SAVE PRESCRIPTION --------------------------- */
  @override
  FutureResult<String> uploadPrescription(File imageFile) async {
    return await _imageService.saveImage(
        folderName: 'lab_prescription', imageFile: imageFile);
  }

  /* ----------------------------- GET LAB ORDERS ----------------------------- */

  @override
  Stream<Either<MainFailure, List<LabOrdersModel>>> getLabOrders() async* {
    try {
      labOrderSubscription = _firestore
          .collection(FirebaseCollections.labOrdersCollection)
          .where('orderStatus', isEqualTo: 0)
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
}
