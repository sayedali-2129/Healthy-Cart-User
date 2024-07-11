import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as log;
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/sound_services.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_banner_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/utils/constants/enums/location_enum.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILabFacade)
class ILabImpl implements ILabFacade {
  ILabImpl(this._firestore, this._soundServices);
  final FirebaseFirestore _firestore;
  final SoundServices _soundServices;
  /* --------------------- Getting Hospital Location Based -------------------- */
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

  final collection = FirebaseCollections.laboratory;
  final baseDir = 'placemark.';
  final timestamp = 'createdAt';
  final locationCollection = 'laboratoryLocation';

  @override
  FutureResult<List<LabModel>> fetchLabortaryLocationBasedData(
      PlaceMark placeMark) async {
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
                  .where('requested', isEqualTo: 2)
                  .where('isActive', isEqualTo: true)
                  .orderBy(timestamp)
                  .limit(limit)
                  .get()
              : await FirebaseFirestore.instance
                  .collection(collection)
                  .where('${baseDir}district', isEqualTo: placeMark.district)
                  .where('${baseDir}localArea', isEqualTo: placeMark.localArea)
                  .where('requested', isEqualTo: 2)
                  .where('isActive', isEqualTo: true)
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
                    .where('requested', isEqualTo: 2)
                    .where('isActive', isEqualTo: true)
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
                    .where('requested', isEqualTo: 2)
                    .where('isActive', isEqualTo: true)
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
                    .where('requested', isEqualTo: 2)
                    .where('isActive', isEqualTo: true)
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
                    .where('requested', isEqualTo: 2)
                    .where('isActive', isEqualTo: true)
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
                    .where('requested', isEqualTo: 2)
                    .where('isActive', isEqualTo: true)
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
                    .where('requested', isEqualTo: 2)
                    .where('isActive', isEqualTo: true)
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

      return right(docList.map((e) => LabModel.fromMap(e.data())).toList());
    } on FirebaseException catch (e) {
      log.log(e.toString());
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
  void clearLabortaryLocationData() {
    locationSortEnum = LocationSortEnum.localArea;
    lastdoc = null;
    currentIndex = 0;
    currentDistrictIndex = 0;
    currentStateIndex = 0;
  }

  @override
  FutureResult<Unit> fecthLabortaryLocation(PlaceMark placeMark) async {
    try {
      final futureList = <Future<DocumentSnapshot<Map<String, dynamic>>>>[
        // get district doc
        _firestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .collection(placeMark.state)
            .doc(placeMark.state)
            .collection(placeMark.district)
            .doc(placeMark.district)
            .get(),
        // get state doc
        _firestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .collection(placeMark.state)
            .doc(placeMark.state)
            .get(),
        // get country doc
        _firestore.collection(locationCollection).doc(placeMark.country).get(),
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

/* -------------------------------------------------------------------------- */

/* ------------------------------ GET ALL LABS ------------------------------ */

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  @override
  FutureResult<List<LabModel>> getLabs({required String? labSearch}) async {
    if (noMoreData) return right([]);

    try {
      Query query = _firestore
          .collection(FirebaseCollections.laboratory)
          .orderBy('createdAt', descending: true)
          .where('requested', isEqualTo: 2)
          .where('isActive', isEqualTo: true);
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

  @override
  Future<void> playPaymentSound() async {
    await _soundServices.loadSound();
  }
}
