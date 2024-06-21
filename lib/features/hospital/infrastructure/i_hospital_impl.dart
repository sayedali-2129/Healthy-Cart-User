import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IHospitalFacade)
class IHospitalImpl implements IHospitalFacade {
  IHospitalImpl(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentSnapshot<Map<String, dynamic>>? hospitalLastDoc;
  bool hospitalNoMoreData = false;

/* ---------------------------- GET ALL HOSPITALS --------------------------- */
  @override
  FutureResult<List<HospitalModel>> getAllHospitals(
      {String? hospitalSearch}) async {
    if (hospitalNoMoreData) return right([]);
    try {
      Query query = _firestore
          .collection(FirebaseCollections.hospitalCollection)
          .where('requested', isEqualTo: 2)
          .orderBy('createdAt', descending: true);

      if (hospitalSearch != null && hospitalSearch.isNotEmpty) {
        query = query.where('keywords',
            arrayContains: hospitalSearch.toLowerCase());
      }

      if (hospitalLastDoc != null) {
        query = query.startAfterDocument(hospitalLastDoc!);
      }
      final snapshot = await query.limit(5).get();
      if (snapshot.docs.length < 5 || snapshot.docs.isEmpty) {
        hospitalNoMoreData = true;
      } else {
        hospitalLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }

      return right(snapshot.docs
          .map((e) => HospitalModel.fromMap(e.data() as Map<String, dynamic>)
              .copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearHospitalData() {
    hospitalLastDoc = null;
    hospitalNoMoreData = false;
  }

  @override
  FutureResult<List<HospitalBannerModel>> getHospitalBanner(
      {required String hospitalId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.hospitalBannerCollection)
          .where('hospitalId', isEqualTo: hospitalId)
          .orderBy('isCreated', descending: true)
          .get();

      return right(responce.docs
          .map((e) => HospitalBannerModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
