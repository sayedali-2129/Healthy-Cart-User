import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
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

/* --------------------------- GET HOSPITAL BANNER -------------------------- */
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

/* -------------------------- GET HOSPITAL CATRGORY ------------------------- */
  @override
  FutureResult<List<HospitalCategoryModel>> getHospitalCategory(
      {required List<String> categoryIdList}) async {
    try {
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];

      for (var element in categoryIdList) {
        futures.add(_firestore
            .collection(FirebaseCollections.doctorCategory)
            .doc(element)
            .get());
      }

      List<DocumentSnapshot<Map<String, dynamic>>> result =
          await Future.wait<DocumentSnapshot<Map<String, dynamic>>>(futures);

      final categoryList = result
          .map<HospitalCategoryModel>((e) =>
              HospitalCategoryModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();

      return right(categoryList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ------------------------------- GET DOCTRS ------------------------------- */

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  @override
  FutureResult<List<DoctorModel>> getDoctors(
      {required String hospitalId,
      String? doctorSearch,
      String? categoryId}) async {
    if (noMoreData) return right([]);
    try {
      Query query = _firestore
          .collection(FirebaseCollections.doctorCollection)
          .where('hospitalId', isEqualTo: hospitalId)
          .orderBy('createdAt', descending: true);
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }

      if (doctorSearch != null && doctorSearch.isNotEmpty) {
        query =
            query.where('keywords', arrayContains: doctorSearch.toLowerCase());
      }
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }
      final snapshot = await query.limit(12).get();
      if (snapshot.docs.length < 12 || snapshot.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      return right(snapshot.docs
          .map((e) => DoctorModel.fromMap(e.data() as Map<String, dynamic>)
              .copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearDoctorData() {
    lastDoc = null;
    noMoreData = false;
  }
}
