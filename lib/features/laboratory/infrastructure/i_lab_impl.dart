import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_banner_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILabFacade)
class ILabImpl implements ILabFacade {
  ILabImpl(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;

/* ------------------------------ GET ALL LABS ------------------------------ */
  @override
  FutureResult<List<LabModel>> getLabs({required String? labSearch}) async {
    if (noMoreData) return right([]);

    try {
      Query query = _firestore
          .collection(FirebaseCollections.laboratory)
          .where('requested', isEqualTo: 2)
          .orderBy('createdAt', descending: true);

      if (labSearch != null && labSearch.isNotEmpty) {
        query = query.where('keywords', arrayContains: labSearch.toLowerCase());
      }
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }
      final snapshot = await query.limit(10).get();
      if (snapshot.docs.length < 10 || snapshot.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final labList = snapshot.docs
          .map(
            (e) => LabModel.fromMap(e.data() as Map<String, dynamic>)
                .copyWith(id: e.id),
          )
          .toList();
      return right(labList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
  /* -------------------------------------------------------------------------- */

  @override
  void clearData() {
    lastDoc = null;
    noMoreData = false;
  }

/* ----------------------------- GET LAB BANNERS ---------------------------- */
  @override
  FutureResult<List<LabBannerModel>> getLabBanner({required labId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.laboratoryBanner)
          .orderBy('isCreated', descending: true)
          .where('hospitalId', isEqualTo: labId)
          .get();

      final bannerList = responce.docs
          .map((e) => LabBannerModel.fromMap(e.data()).copyWith(id: e.id))
          .toList();
      return right(bannerList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ---------------------------- GET ALL LAB TESTS --------------------------- */

  @override
  FutureResult<List<LabTestModel>> getAvailableTests({required labId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.laboratoryTests)
          .orderBy('createdAt', descending: true)
          .where('labId', isEqualTo: labId)
          .get();

      final testList = responce.docs
          .map((e) => LabTestModel.fromMap(e.data()).copyWith(id: e.id))
          .toList();
      return right(testList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* -------------------------- DOOR STEP ONLY TESTS -------------------------- */
  @override
  FutureResult<List<LabTestModel>> getDoorStepOnly({required labId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.laboratoryTests)
          .orderBy('createdAt', descending: true)
          .where(Filter.and(Filter('labId', isEqualTo: labId),
              Filter('isDoorstepAvailable', isEqualTo: true)))
          .get();

      final doorStepTestList = responce.docs
          .map((e) => LabTestModel.fromMap(e.data()).copyWith(id: e.id))
          .toList();
      return right(doorStepTestList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
