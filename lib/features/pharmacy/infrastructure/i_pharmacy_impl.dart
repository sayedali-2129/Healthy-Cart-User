//import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/image_picker.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_banner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/utils/constants/enums/location_enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPharmacyFacade)
class IPharmacyImpl implements IPharmacyFacade {
  IPharmacyImpl(this._firebaseFirestore, this._imageService);
  final FirebaseFirestore _firebaseFirestore;
  final ImageService _imageService;

//// Image section --------------------------
  @override
  FutureResult<File> getImage({required ImageSource imagesource}) async {
    return await _imageService.getGalleryImage(imagesource: imagesource);
  }

  @override
  FutureResult<String> saveImage({required File imageFile}) async {
    return await _imageService.saveImage(
        imageFile: imageFile, folderName: 'pharmacyUserSide_image');
  }

  /* --------------------- Getting Pharmacy Location Based -------------------- */
  QueryDocumentSnapshot<Map<String, dynamic>>? lastdoc;
  int limit = 10;
  //
  List<List<String>> localAreaSubList = [];
  List<List<String>> districtSubList = [];
  List<List<String>> stateSubList = [];
  int currentIndex = 0;
  int currentDistrictIndex = 0;
  int currentStateIndex = 0;
  final collection = FirebaseCollections.pharmacy;
  final baseDir = 'placemark.';
  final timestamp = 'createdAt';
  final locationCollection = 'pharmacy_locations';
  LocationSortEnum locationSortEnum = LocationSortEnum.localArea;
  @override
  FutureResult<List<PharmacyModel>> fetchPharmacyLocationBasedData(
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
                  .where('pharmacyRequested', isEqualTo: 2)
                  .where('isActive', isEqualTo: true)
                  .orderBy(timestamp)
                  .limit(limit)
                  .get()
              : await FirebaseFirestore.instance
                  .collection(collection)
                  .where('${baseDir}district', isEqualTo: placeMark.district)
                  .where('${baseDir}localArea', isEqualTo: placeMark.localArea)
                  .where('pharmacyRequested', isEqualTo: 2)
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
                    .where('pharmacyRequested', isEqualTo: 2)
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
                    .where('pharmacyRequested', isEqualTo: 2)
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
                    .where('pharmacyRequested', isEqualTo: 2)
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
                    .where('pharmacyRequested', isEqualTo: 2)
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
       //   log.log(stateList.toString());

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
                    .where('pharmacyRequested', isEqualTo: 2)
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
                    .where('pharmacyRequested', isEqualTo: 2)
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

           // log.log('currentStateIndex=$currentStateIndex');
          } while (currentStateIndex <= (stateList.length - 1));
        } else {
          lastdoc = null;
          locationSortEnum = LocationSortEnum.noDataFound;
        }
      }

      return right(
          docList.map((e) => PharmacyModel.fromMap(e.data())).toList());
    } on FirebaseException catch (e) {
     // log.log(e.toString());
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
  void clearPharmacyLocationData() {
    locationSortEnum = LocationSortEnum.localArea;
    lastdoc = null;
    currentIndex = 0;
    currentDistrictIndex = 0;
    currentStateIndex = 0;
  }

  @override
  FutureResult<Unit> fecthPharmacyLocation(PlaceMark placeMark) async {
    try {
      final futureList = <Future<DocumentSnapshot<Map<String, dynamic>>>>[
        // get district doc
        _firebaseFirestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .collection(placeMark.state)
            .doc(placeMark.state)
            .collection(placeMark.district)
            .doc(placeMark.district)
            .get(),
        // get state doc
        _firebaseFirestore
            .collection(locationCollection)
            .doc(placeMark.country)
            .collection(placeMark.state)
            .doc(placeMark.state)
            .get(),
        // get country doc
        _firebaseFirestore
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

/* ----------------------- Get ALL SEARCH AND PHARMaCY ---------------------- */
  DocumentSnapshot<Map<String, dynamic>>? lastPharmacyDoc;
  bool noMorePharmacyData = false;

  @override
  void clearPharmacyFetchData() {
    noMorePharmacyData = false;
    lastPharmacyDoc = null;
  }

  @override
  FutureResult<List<PharmacyModel>> getAllPharmacy(
      {required String? searchText}) async {
    try {
      if (noMorePharmacyData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacy)
          .orderBy('createdAt', descending: true)
          .where('pharmacyRequested', isEqualTo: 2)
          .where('isActive', isEqualTo: true);

      if (searchText != null && searchText.isNotEmpty) {
        query = query.where(
          'pharmacyKeywords',
          arrayContains: searchText.toLowerCase().replaceAll(' ', ''),
        );
      }
      if (lastPharmacyDoc != null) {
        query = query.startAfterDocument(lastPharmacyDoc!);
      //  log.log(lastPharmacyDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMorePharmacyData = true;
      } else {
        lastPharmacyDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyModel> pharmacyList = snapshots.docs
          .map((e) => PharmacyModel.fromMap(e.data() as Map<String, dynamic>)
              .copyWith(id: e.id))
          .toList();
      return right(pharmacyList);
    } on FirebaseException catch (e) {
      //log.log(e.code);
      //log.log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastAllProductDoc;
  bool noMoreAllProductData = false;
  @override
  void clearPharmacyAllProductFetchData() {
    lastAllProductDoc = null;
    noMoreAllProductData = false;
  }

  @override
  FutureResult<List<PharmacyProductAddModel>> getPharmacyAllProductDetails({
    required String? pharmacyId,
    required String? searchText,
  }) async {
    try {
      if (noMoreAllProductData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId);

      if (searchText != null && searchText.isNotEmpty) {
        query = query.where(
          'keywords',
          arrayContains: searchText.toLowerCase().replaceAll(' ', ''),
        );
      }
      if (lastAllProductDoc != null) {
        query = query.startAfterDocument(lastAllProductDoc!);
       // log.log(lastAllProductDoc!.id.toString());
      }
      final snapshots = await query.limit(4).get();
      if (snapshots.docs.length < 4 || snapshots.docs.isEmpty) {
        noMoreAllProductData = true;
      } else {
        lastAllProductDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyProductAddModel> productList = snapshots.docs
          .map((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
     // log.log(e.code);
      //log.log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastCategoryProductDoc;
  bool noMoreCategoryProductData = false;

  @override
  void clearPharmacyCategoryProductFetchData() {
    noMoreCategoryProductData = false;
    lastCategoryProductDoc = null;
  }

  @override
  FutureResult<List<PharmacyProductAddModel>>
      getPharmacyCategoryProductDetails({
    required String? categoryId,
    required String? pharmacyId,
    required String? searchText,
  }) async {
    try {
      if (noMoreCategoryProductData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('categoryId', isEqualTo: categoryId);
     // log.log('Category Id from Implementation  $categoryId');
      if (searchText != null && searchText.isNotEmpty) {
        query =
            query.where('keywords', arrayContains: searchText.toLowerCase());
      }
      if (lastCategoryProductDoc != null) {
        query = query.startAfterDocument(lastCategoryProductDoc!);
       // log.log(lastCategoryProductDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMoreCategoryProductData = true;
      } else {
        lastCategoryProductDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyProductAddModel> productList = snapshots.docs
          .map((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
    //  log.log(e.code);
      //log.log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyCategoryModel>> getpharmacyCategory(
      {required List<String> categoryIdList}) async {
    try {
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];

      for (var element in categoryIdList) {
        futures.add(_firebaseFirestore
            .collection(FirebaseCollections.pharmacycategory)
            .doc(element)
            .get());
      }

      List<DocumentSnapshot<Map<String, dynamic>>> results =
          await Future.wait<DocumentSnapshot<Map<String, dynamic>>>(futures);

      final categoryList = results
          .map<PharmacyCategoryModel>((e) =>
              PharmacyCategoryModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();

      return right(categoryList);
    } on FirebaseException catch (e) {
     // log.log(e.toString());
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
    //  log.log(e.toString());

      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyBannerModel>> getPharmacyBanner(
      {required String pharmacyId}) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyBanner)
          .orderBy('isCreated', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .get();
      return right([
        ...snapshot.docs.map(
            (e) => PharmacyBannerModel.fromMap(e.data()).copyWith(id: e.id))
      ]);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.toString()));
    }
  }

  /* ------------------------- PRODUCT IN CART ------------------------- */
  @override
  FutureResult<Map<String, dynamic>> createOrGetProductToUserCart({
    required String pharmacyId,
    required String userId,
  }) async {
    //log.log('userId $userId');
    //log.log('pharmacyId $pharmacyId');
    try {
      final docRef = _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.pharmacyCart)
          .doc(pharmacyId);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final productDetails = snapshot.data();
        Map<String, dynamic> productData = productDetails?['productDetails'];
        return right(productData);
      } else {
        await docRef.set({'productDetails': {}});
        return right({});
      }
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<Map<String, int>> addProductToUserCart({
    required Map<String, int> cartProduct,
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final docRef = _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.pharmacyCart)
          .doc(pharmacyId);
      // Update the Firestore document with the modified list
      await docRef
          .set({'productDetails': cartProduct}, SetOptions(merge: true));
      return right(cartProduct);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyProductAddModel>> getpharmcyCartProduct(
      {required List<String> productCartIdList}) async {
    try {
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];
      for (var element in productCartIdList) {
        futures.add(_firebaseFirestore
            .collection(FirebaseCollections.pharmacyProduct)
            .doc(element)
            .get());
      }

      List<DocumentSnapshot<Map<String, dynamic>>> results =
          await Future.wait<DocumentSnapshot<Map<String, dynamic>>>(futures);

      final cartProductList = results
          .map<PharmacyProductAddModel>((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(cartProductList);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<Unit> removeProductFromUserCart({
    required String cartProductId,
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final docRef = _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.pharmacyCart)
          .doc(pharmacyId);
      // Update the Firestore document with the modified list
      await docRef.update(
        {'productDetails.$cartProductId': FieldValue.delete()},
      );
      return right(unit);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ------------------------- order and cart section ------------------------- */
  @override
  FutureResult<PharmacyOrderModel> createProductOrderDetails({
    required PharmacyOrderModel orderProducts,
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final batch = _firebaseFirestore.batch();
      final id = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc()
          .id;
      orderProducts.id = id;
      batch.set(
          _firebaseFirestore
              .collection(FirebaseCollections.pharmacyOrder)
              .doc(id),
          orderProducts.toMap());
      batch.set(
          _firebaseFirestore
              .collection(FirebaseCollections.userCollection)
              .doc(userId)
              .collection(FirebaseCollections.pharmacyCart)
              .doc(pharmacyId),
          {'productDetails': {}});
      await batch.commit();
      return right(orderProducts.copyWith(id: id));
    } on FirebaseException catch (e) {
     // log.log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastProductOrderDoc;
  bool noMoreProductOrderData = false;
  @override
  FutureResult<List<PharmacyOrderModel>> getProductOrderDetails(
      {required String userId, required String pharmacyId}) async {
    try {
      if (noMoreProductOrderData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('createdAt', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('userId', isEqualTo: userId);
      if (lastProductOrderDoc != null) {
        query = query.startAfterDocument(lastProductOrderDoc!);
        //log.log(lastProductOrderDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMoreProductOrderData = true;
      } else {
        lastProductOrderDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyOrderModel> productOrderList = snapshots.docs
          .map((e) =>
              PharmacyOrderModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productOrderList);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearProductOrderFetchData() {
    lastProductOrderDoc = null;
    noMoreProductOrderData = false;
  }

  @override
  FutureResult<PharmacyOrderModel> updateProductOrderDetails(
      {required String orderProductId,
      required PharmacyOrderModel orderProducts}) async {
   // log.log(orderProductId);
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderProductId)
          .update(orderProducts.toMap());

      return right(orderProducts.copyWith(id: orderProductId));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ------------------------ GETTING A SINGLE PHARMACY FOR HOSPITAL SIDE----------------------- */
  @override
  FutureResult<PharmacyModel> getSinglePharmacy(
      {required String pharmacyId}) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacy)
          .doc(pharmacyId)
          .get();
      if (result.exists) {
        return right(
            PharmacyModel.fromMap(result.data()!).copyWith(id: result.id));
      } else {
        //log.log('That pharmacy of hospital Not Available');
        return left(const MainFailure.generalException(errMsg: ''));
      }
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
  /* -------------------------------------------------------------------------- */
}
