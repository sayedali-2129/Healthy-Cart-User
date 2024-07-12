import 'dart:async';
import 'dart:math';
import 'dart:developer' as log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_booking_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/utils/constants/enums/location_enum.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IHospitalBookingFacade)
class IHospitalBookingImpl implements IHospitalBookingFacade {
  IHospitalBookingImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  FutureResult<String> createHospitalBooking(
      {required HospitalBookingModel hospitalBookingModel}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .add(hospitalBookingModel.toMap());
      return right('Booking Request Send Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<HospitalBookingModel>> getPendingOrders(
      {required String userId}) async {
    try {
      final responce = await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 0)))
          .orderBy('bookedAt', descending: true)
          .get();

      return right(responce.docs
          .map((e) => HospitalBookingModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ---------------------- GET APPROVED HOSPITAL BOOKING --------------------- */
  StreamSubscription? hospOrderSubscription;

  StreamController<Either<MainFailure, List<HospitalBookingModel>>>
      hospOrderController = StreamController<
          Either<MainFailure, List<HospitalBookingModel>>>.broadcast();
  @override
  Stream<Either<MainFailure, List<HospitalBookingModel>>> getAcceptedOrders(
      {required String userId}) async* {
    try {
      hospOrderSubscription = _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(
            Filter('userId', isEqualTo: userId),
            Filter('orderStatus', isEqualTo: 1),
          ))
          .orderBy('acceptedAt', descending: true)
          .snapshots()
          .listen(
        (doc) {
          hospOrderController.add(right(doc.docs
              .map((e) =>
                  HospitalBookingModel.fromMap(e.data()).copyWith(id: e.id))
              .toList()));
        },
      );
    } catch (e) {
      hospOrderController
          .add(left(MainFailure.generalException(errMsg: e.toString())));
    }
    yield* hospOrderController.stream;
  }

  /* -------------------------- GET CANCELLED ORDERS -------------------------- */
  DocumentSnapshot<Map<String, dynamic>>? cancelledLastDoc;
  bool cancelledNoMoreData = false;
  @override
  FutureResult<List<HospitalBookingModel>> getCancelledOrders(
      {required String userId}) async {
    if (cancelledNoMoreData) return right([]);
    int limit = cancelledLastDoc == null ? 10 : 5;
    try {
      Query query = _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 3)))
          .orderBy('rejectedAt', descending: true);
      if (cancelledLastDoc != null) {
        query = query.startAfterDocument(cancelledLastDoc!);
      }
      final snapshot = await query.limit(limit).get();
      if (snapshot.docs.length < limit || snapshot.docs.isEmpty) {
        cancelledNoMoreData = true;
      } else {
        cancelledLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      return right(snapshot.docs
          .map((e) =>
              HospitalBookingModel.fromMap(e.data() as Map<String, dynamic>)
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

  /* -------------------------- CANCEL ORDER BY USER -------------------------- */
  @override
  FutureResult<String> cancelOrder({required String orderId}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .doc(orderId)
          .update({'orderStatus': 3, 'rejectedAt': Timestamp.now()});
      return right('Booking Cancelled Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ---------------------------- UPDATE ORDER STATUS TO ON PROCESS -------------------------- */
/* -------------------------------------------------------------------------- */
  @override
  FutureResult<String> acceptOrder(
      {required String orderId, required String paymentMethod}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
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

  /* -------------------------- GET COMPLETED ORDERS -------------------------- */
  DocumentSnapshot<Map<String, dynamic>>? completedLastDoc;
  bool completedNoMoreData = false;

  @override
  FutureResult<List<HospitalBookingModel>> getCompletedOrders(
      {required String userId}) async {
    if (completedNoMoreData) return right([]);

    int limit = completedLastDoc == null ? 8 : 4;
    try {
      Query query = _firestore
          .collection(FirebaseCollections.hospitalBookingCollection)
          .where(Filter.and(Filter('userId', isEqualTo: userId),
              Filter('orderStatus', isEqualTo: 2)))
          .orderBy('completedAt', descending: true);
      if (completedLastDoc != null) {
        query = query.startAfterDocument(completedLastDoc!);
      }
      final snapshot = await query.limit(limit).get();
      if (snapshot.docs.length < limit || snapshot.docs.isEmpty) {
        completedNoMoreData = true;
      } else {
        completedLastDoc =
            snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }

      return right(snapshot.docs
          .map((e) =>
              HospitalBookingModel.fromMap(e.data() as Map<String, dynamic>)
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

  /* --------------------- Getting Doctor Location Based -------------------- */
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

  final collection = FirebaseCollections.doctorCollection;
  final baseDir = 'placemark.';
  final timestamp = 'createdAt';
  final locationCollection = 'hospitalLocations';

  @override
  FutureResult<List<DoctorModel>> fetchAllDoctorsCategoryWiseLocationBasedData({
    required PlaceMark placeMark,
    required String categoryId,
  }) async {
    log.log('categoryId fffffffffff $categoryId');
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
                  .where('categoryId', isEqualTo: categoryId)
                  .orderBy(timestamp)
                  .limit(limit)
                  .get()
              : await FirebaseFirestore.instance
                  .collection(collection)
                  .where('${baseDir}district', isEqualTo: placeMark.district)
                  .where('${baseDir}localArea', isEqualTo: placeMark.localArea)
                  .where('categoryId', isEqualTo: categoryId)
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
                    .where('categoryId', isEqualTo: categoryId)
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
                    .where('categoryId', isEqualTo: categoryId)
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
                    .where('categoryId', isEqualTo: categoryId)
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
                    .where('categoryId', isEqualTo: categoryId)
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
                    .where('categoryId', isEqualTo: categoryId)
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
                    .where('categoryId', isEqualTo: categoryId)
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

      return right(docList.map((e) => DoctorModel.fromMap(e.data())).toList());
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
  void clearAllDoctorsCategoryWiseLocationData() {
    locationSortEnum = LocationSortEnum.localArea;
    lastdoc = null;
    currentIndex = 0;
    currentDistrictIndex = 0;
    currentStateIndex = 0;
  }

  @override
  FutureResult<Unit> fectchAllDoctorsCategoryWiseLocation(
      PlaceMark placeMark) async {
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
}
