import 'dart:math';
import 'dart:developer' as log;
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
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/utils/constants/enums/location_enum.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: IHospitalFacade)
class IHospitalImpl implements IHospitalFacade {
  IHospitalImpl(this.firebaseFirestore);
  final FirebaseFirestore firebaseFirestore;
  LocationSortEnum locationSortEnum = LocationSortEnum.localArea;
  QueryDocumentSnapshot<Map<String, dynamic>>? lastdoc;
  int limit = 10;
  //
  List<List<String>> localAreaSubList = [];
  List<List<String>> districtSubList = [];
  List<List<String>> stateSubList = [];
  int currentIndex = 0;
  int currentDistrictIndex = 0;
  int currentStateIndex = 0;

  //
  final collection = FirebaseCollections.hospitalCollection;
  final baseDir = 'placemark.';
  final timestamp = 'createdAt';
  final locationCollection = 'hospitalLocations';

  @override
  FutureResult<List<HospitalModel>> fetchProduct(PlaceMark placeMark) async {
    if (locationSortEnum == LocationSortEnum.noDataFound) {
      return left(
        const MainFailure.generalException(errMsg: 'No data found!'),
      );
    }
    try {
      final docList = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

      // LocalArea
      if (locationSortEnum == LocationSortEnum.localArea) {
        if (localAreaSubList.isNotEmpty) {
          QuerySnapshot<Map<String, dynamic>> refreshedClass;
          refreshedClass = (lastdoc == null)
              ? await FirebaseFirestore.instance
                  .collection(collection)
                  .where('${baseDir}district', isEqualTo: placeMark.district)
                  .where('${baseDir}localArea', isEqualTo: placeMark.localArea)
                  .orderBy(timestamp)
                  .limit(limit)
                  .get()
              : await FirebaseFirestore.instance
                  .collection(collection)
                  .where('${baseDir}district', isEqualTo: placeMark.district)
                  .where('${baseDir}localArea', isEqualTo: placeMark.localArea)
                  .orderBy(timestamp)
                  .startAfterDocument(lastdoc!)
                  .limit(limit)
                  .get();

          if (refreshedClass.docs.length >= limit) {
            lastdoc = refreshedClass.docs.last;
          } else {
            lastdoc = null;
            locationSortEnum = LocationSortEnum.district;
          }
          docList.addAll(refreshedClass.docs);
        } else {
          // localAreaSubList Empty
          lastdoc = null;
          locationSortEnum = LocationSortEnum.district;
        }
      }
      //LocalArea END
      //

      // District
      if (locationSortEnum == LocationSortEnum.district) {
        final localAreaList = removeCurrentLocationElement(
          localAreaSubList,
          placeMark.localArea ?? '',
        );
        if (localAreaList.isNotEmpty) {
          do {
            QuerySnapshot<Map<String, dynamic>> refreshedClass;

            refreshedClass = (lastdoc == null)
                ? await FirebaseFirestore.instance
                    .collection(collection)
                    .where('${baseDir}district', isEqualTo: placeMark.district)
                    .where(
                      '${baseDir}localArea',
                      whereIn: localAreaList[currentIndex],
                    )
                    .orderBy(timestamp)
                    .limit(limit)
                    .get()
                : await FirebaseFirestore.instance
                    .collection(collection)
                    .where('${baseDir}district', isEqualTo: placeMark.district)
                    .where(
                      '${baseDir}localArea',
                      whereIn: localAreaList[currentIndex],
                    )
                    .orderBy(timestamp)
                    .startAfterDocument(lastdoc!)
                    .limit(limit)
                    .get();

            if (refreshedClass.docs.length < limit) {
              currentIndex++;
              if ((localAreaList.length - 1) >= currentIndex) {
                docList.addAll(refreshedClass.docs);
                lastdoc = null;
                continue;
              } else {
                docList.addAll(refreshedClass.docs);
                lastdoc = null;
                locationSortEnum = LocationSortEnum.state;
              }
            } else {
              lastdoc = refreshedClass.docs.last;
              docList.addAll(refreshedClass.docs);
              break;
            }
          } while (currentIndex <= (localAreaList.length - 1));
        } else {
          lastdoc = null;
          locationSortEnum = LocationSortEnum.state;
        }
      }

      // State
      if (locationSortEnum == LocationSortEnum.state) {
        final districtList = removeCurrentLocationElement(
          districtSubList,
          placeMark.district,
        );

        if (districtList.isNotEmpty) {
          do {
            QuerySnapshot<Map<String, dynamic>> refreshedClass;

            refreshedClass = (lastdoc == null)
                ? await FirebaseFirestore.instance
                    .collection(collection)
                    .where('${baseDir}state', isEqualTo: placeMark.state)
                    .where(
                      '${baseDir}district',
                      whereIn: districtList[currentDistrictIndex],
                    )
                    .orderBy(timestamp)
                    .limit(limit)
                    .get()
                : await FirebaseFirestore.instance
                    .collection(collection)
                    .where('${baseDir}state', isEqualTo: placeMark.state)
                    .where(
                      '${baseDir}district',
                      whereIn: districtList[currentDistrictIndex],
                    )
                    .orderBy(timestamp)
                    .startAfterDocument(lastdoc!)
                    .limit(limit)
                    .get();

            if (refreshedClass.docs.length < limit) {
              currentDistrictIndex++;
              if ((districtList.length - 1) >= currentDistrictIndex) {
                docList.addAll(refreshedClass.docs);
                lastdoc = null;
                continue;
              } else {
                docList.addAll(refreshedClass.docs);
                lastdoc = null;
                locationSortEnum = LocationSortEnum.contrary;
              }
            } else {
              lastdoc = refreshedClass.docs.last;
              docList.addAll(refreshedClass.docs);
              break;
            }
          } while (currentDistrictIndex <= (districtList.length - 1));
        } else {
          lastdoc = null;
          locationSortEnum = LocationSortEnum.contrary;
        }
      }

      // Contrary
      if (locationSortEnum == LocationSortEnum.contrary) {
        final stateList = removeCurrentLocationElement(
          stateSubList,
          placeMark.state,
        );

        if (stateList.isNotEmpty) {
          log.log(stateList.toString());

          do {
            QuerySnapshot<Map<String, dynamic>> refreshedClass;

            refreshedClass = (lastdoc == null)
                ? await FirebaseFirestore.instance
                    .collection(collection)
                    .where('${baseDir}country', isEqualTo: placeMark.country)
                    .where(
                      '${baseDir}state',
                      whereIn: stateList[currentStateIndex],
                    )
                    .orderBy(timestamp)
                    .limit(limit)
                    .get()
                : await FirebaseFirestore.instance
                    .collection(collection)
                    .where('${baseDir}country', isEqualTo: placeMark.country)
                    .where(
                      '${baseDir}state',
                      whereIn: stateList[currentStateIndex],
                    )
                    .orderBy(timestamp)
                    .startAfterDocument(lastdoc!)
                    .limit(limit)
                    .get();

            if (refreshedClass.docs.length < limit) {
              currentStateIndex++;
              if ((stateList.length - 1) >= currentStateIndex) {
                docList.addAll(refreshedClass.docs);
                lastdoc = null;
                continue;
              } else {
                docList.addAll(refreshedClass.docs);
                lastdoc = null;
                locationSortEnum = LocationSortEnum.noDataFound;
              }
            } else {
              lastdoc = refreshedClass.docs.last;
              docList.addAll(refreshedClass.docs);
              break;
            }

            log.log('currentStateIndex=$currentStateIndex');
          } while (currentStateIndex <= (stateList.length - 1));
        } else {
          lastdoc = null;
          locationSortEnum = LocationSortEnum.noDataFound;
        }
      }

      return right(
          docList.map((e) => HospitalModel.fromMap(e.data())).toList());
    } on FirebaseException catch (e) {
      return left(
        MainFailure.firebaseException(errMsg: e.code),
      );
    } on Exception catch (e) {
      return left(
        MainFailure.firebaseException(errMsg: '$e'),
      );
    }
  }

  @override
  void clearData() {
    locationSortEnum = LocationSortEnum.localArea;
    lastdoc = null;
    currentIndex = 0;
    currentDistrictIndex = 0;
    currentStateIndex = 0;
  }

  @override
  FutureResult<Unit> fecthUserLocaltion(PlaceMark placeMark) async {
    try {
      final futureList = <Future<DocumentSnapshot<Map<String, dynamic>>>>[
        // get district doc
        firebaseFirestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .collection(placeMark.state)
            .doc(placeMark.state)
            .collection(placeMark.district)
            .doc(placeMark.district)
            .get(),
        // get state doc
        firebaseFirestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .collection(placeMark.state)
            .doc(placeMark.state)
            .get(),
        // get country doc
        firebaseFirestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .get(),
      ];
      var localAreaList = <String>[];
      var districtList = <String>[];
      var stateList = <String>[];
      final location = await Future.wait(futureList);
      // district
      if (location[0].exists) {
        final localAreaData =
            location[0].data()?['localArea'] as List<dynamic>?;
        if (localAreaData != null) {
          localAreaList = sortNearBy(
            localAreaData,
            GeoPoint(placeMark.geoPoint.latitude, placeMark.geoPoint.longitude),
          );
        }
      }

      // state
      if (location[1].exists) {
        final districtData = location[1].data()?['district'] as List<dynamic>?;
        if (districtData != null) {
          districtList = sortNearBy(
            districtData,
            GeoPoint(placeMark.geoPoint.latitude, placeMark.geoPoint.longitude),
          );
        }
      }

      // country
      if (location[2].exists) {
        final stateData = location[2].data()?['state'] as List<dynamic>?;
        if (stateData != null) {
          stateList = sortNearBy(
            stateData,
            GeoPoint(placeMark.geoPoint.latitude, placeMark.geoPoint.longitude),
          );
        }
      }
      // log.log('localAreaList = $localAreaList');
      // log.log('districtList = $districtList');
      // log.log('stateList = $stateList');
      localAreaSubList = _splitLocation(localAreaList, 10);
      districtSubList = _splitLocation(districtList, 10);
      stateSubList = _splitLocation(stateList, 10);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(
        MainFailure.firebaseException(errMsg: e.code),
      );
    } on Exception catch (e) {
      return left(
        MainFailure.firebaseException(errMsg: '$e'),
      );
    }
  }

  List<List<String>> _splitLocation(List<String> location, int chunkSize) {
    final result = <List<String>>[];
    for (var i = 0; i < location.length; i += chunkSize) {
      final end =
          (i + chunkSize < location.length) ? i + chunkSize : location.length;
      result.add(location.sublist(i, end));
    }
    return result;
  }

  List<List<String>> removeCurrentLocationElement(
    List<List<String>> locationSubList,
    String elementToRemove,
  ) {
    return locationSubList
        .map(
          (list) =>
              list.where((element) => element != elementToRemove).toList(),
        )
        .where((list) => list.isNotEmpty)
        .toList();
  }

  List<String> sortNearBy(List<dynamic> listDynamic, GeoPoint currentGeoPoint) {
    final listMap = <Map<String, dynamic>>[];
    for (final element in listDynamic) {
      listMap.add(element as Map<String, dynamic>);
    }

    listMap.sort((a, b) {
      final distanceToA = _haversine(
        currentGeoPoint.latitude,
        currentGeoPoint.longitude,
        // ignore: avoid_dynamic_calls
        a.values.first.latitude as double,
        // ignore: avoid_dynamic_calls
        a.values.first.longitude as double,
      );
      final distanceToB = _haversine(
        currentGeoPoint.latitude,
        currentGeoPoint.longitude,
        // ignore: avoid_dynamic_calls
        b.values.first.latitude as double,
        // ignore: avoid_dynamic_calls
        b.values.first.longitude as double,
      );
      return distanceToA.compareTo(distanceToB);
    });

    return listMap.map((map) => map.keys.first).toList();
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in kilometers
    final dLat = _radians(lat2 - lat1);
    final dLon = _radians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_radians(lat1)) *
            cos(_radians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _radians(double degrees) {
    return degrees * (pi / 180);
  }

  DocumentSnapshot<Map<String, dynamic>>? hospitalLastDoc;
  bool hospitalNoMoreData = false;

/* ---------------------------- GET ALL HOSPITALS --------------------------- */
  @override
  FutureResult<List<HospitalModel>> getAllHospitals(
      {String? hospitalSearch}) async {
    if (hospitalNoMoreData) return right([]);
    try {
      Query query = firebaseFirestore
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
      final responce = await firebaseFirestore
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
        futures.add(firebaseFirestore
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
      Query query = firebaseFirestore
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
