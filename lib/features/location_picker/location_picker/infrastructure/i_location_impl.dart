import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/location_service.dart';
import 'package:healthy_cart_user/core/services/open_street_map/open_sctrict_map_services.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/i_location_facde.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ILocationFacade)
class ILocationImpl implements ILocationFacade {
  ILocationImpl(
    this._locationService,
    this._firebaseFirestore,
  );

  final LocationService _locationService;
  final FirebaseFirestore _firebaseFirestore;
  @override
  Future<Either<MainFailure, PlaceMark?>> getCurrentLocationAddress() async {
    try {
      final getCurrentPosition = await Geolocator.getCurrentPosition();

      final getCurrentLocation = await OpenStritMapServices.fetchCurrentLocaion(
          latitude: getCurrentPosition.latitude.toString(),
          longitude: getCurrentPosition.longitude.toString());
      return right(getCurrentLocation);
    } catch (ex) {
      return left(MainFailure.locationError(errMsg: ex.toString()));
    }
  }

  @override
  Future<bool> getLocationPermisson() async {
    await _locationService.getPermission();
    return true;
  }

  @override
  Future<Either<MainFailure, Unit>> setLocationByUser(
      PlaceMark placeMark) async {
    try {
      // add Local area
      final district = await _firebaseFirestore
          .collection(FirebaseCollections.userLocation)
          .doc(placeMark.country)
          .collection(placeMark.state)
          .doc(placeMark.state)
          .collection(placeMark.district)
          .doc(placeMark.district)
          .get();
      if (district.exists) {
        // Get LocalArea Map List // [{Nilambur: Instance of 'GeoPoint'}]
        final localAreaList =
            (district.data()?['localArea'] as List<dynamic>?) ?? [];
        // map convert localArea key then convert
        final localAreaKeysList = <String>[];
        for (final localArea in localAreaList) {
          final localAreaMap = localArea as Map<String, dynamic>;
          // ignore: cascade_invocations
          localAreaMap.forEach((key, value) {
            localAreaKeysList.add(key);
          });
        }

        if (!localAreaKeysList.contains(placeMark.localArea)) {
          await _firebaseFirestore
              .collection(FirebaseCollections.userLocation)
              .doc(placeMark.country)
              .collection(placeMark.state)
              .doc(placeMark.state)
              .collection(placeMark.district)
              .doc(placeMark.district)
              .update({
            'localArea': FieldValue.arrayUnion([
              {
                placeMark.localArea: GeoPoint(
                  placeMark.geoPoint.latitude,
                  placeMark.geoPoint.longitude,
                ),
              },
            ]),
          });
        }
        return right(unit); // stop and set location
      }

      // add district
      final state = await _firebaseFirestore
          .collection(FirebaseCollections.userLocation)
          .doc(placeMark.country)
          .collection(placeMark.state)
          .doc(placeMark.state)
          .get();

      if (state.exists) {
        // Get LocalArea Map List // [{Malappuram: Instance of 'GeoPoint'}]
        final districtList =
            (state.data()?['district'] as List<dynamic>?) ?? [];
        // map convert district key then convert
        final districtKeysList = <String>[];
        for (final district in districtList) {
          final districtMap = district as Map<String, dynamic>;
          // ignore: cascade_invocations
          districtMap.forEach((key, value) {
            districtKeysList.add(key);
          });
        }

        log(districtKeysList.toString());

        final batch = _firebaseFirestore.batch();
        if (!districtKeysList.contains(placeMark.district)) {
          batch.update(
            _firebaseFirestore
                .collection(FirebaseCollections.userLocation)
                .doc(placeMark.country)
                .collection(placeMark.state)
                .doc(placeMark.state),
            {
              'district': FieldValue.arrayUnion([
                {
                  placeMark.district: GeoPoint(
                    placeMark.geoPoint.latitude,
                    placeMark.geoPoint.longitude,
                  ),
                }
              ]),
            },
          );
        }
        batch.set(
          _firebaseFirestore
              .collection(FirebaseCollections.userLocation)
              .doc(placeMark.country)
              .collection(placeMark.state)
              .doc(placeMark.state)
              .collection(placeMark.district)
              .doc(placeMark.district),
          {
            'localArea': FieldValue.arrayUnion([
              {
                placeMark.localArea: GeoPoint(
                  placeMark.geoPoint.latitude,
                  placeMark.geoPoint.longitude,
                ),
              }
            ]),
          },
        );

        await batch.commit();
        return right(unit); // stop and set location
      }

      // add state
      final country = await _firebaseFirestore
          .collection(FirebaseCollections.userLocation)
          .doc(placeMark.country)
          .get();
      if (country.exists) {
        // Get LocalArea Map List // [{Kerala: Instance of 'GeoPoint'}]
        final stateList = (country.data()?['state'] as List<dynamic>?) ?? [];

        // map convert state key then convert
        final stateKeysList = <String>[];
        for (final state in stateList) {
          final stateMap = state as Map<String, dynamic>;
          // ignore: cascade_invocations
          stateMap.forEach((key, value) {
            stateKeysList.add(key);
          });
        }

        final batch = _firebaseFirestore.batch();
        if (!stateKeysList.contains(placeMark.state)) {
          batch.update(
            // update
            _firebaseFirestore
                .collection(FirebaseCollections.userLocation)
                .doc(placeMark.country),
            {
              'state': FieldValue.arrayUnion([
                {
                  placeMark.state: GeoPoint(
                    placeMark.geoPoint.latitude,
                    placeMark.geoPoint.longitude,
                  ),
                }
              ]),
            },
          );
        }
        batch
          ..set(
            _firebaseFirestore
                .collection(FirebaseCollections.userLocation)
                .doc(placeMark.country)
                .collection(placeMark.state)
                .doc(placeMark.state),
            {
              'district': FieldValue.arrayUnion([
                {
                  placeMark.district: GeoPoint(
                    placeMark.geoPoint.latitude,
                    placeMark.geoPoint.longitude,
                  ),
                }
              ]),
            },
          )
          ..set(
            _firebaseFirestore
                .collection(FirebaseCollections.userLocation)
                .doc(placeMark.country)
                .collection(placeMark.state)
                .doc(placeMark.state)
                .collection(placeMark.district)
                .doc(placeMark.district),
            {
              'localArea': FieldValue.arrayUnion([
                {
                  placeMark.localArea: GeoPoint(
                    placeMark.geoPoint.latitude,
                    placeMark.geoPoint.longitude,
                  ),
                }
              ]),
            },
          );

        await batch.commit();
        return right(unit); // stop and set location
      }

      // add country
      final batch = _firebaseFirestore.batch()
        ..set(
          // set
          _firebaseFirestore
              .collection(FirebaseCollections.userLocation)
              .doc(placeMark.country),
          {
            'state': FieldValue.arrayUnion([
              {
                placeMark.state: GeoPoint(
                  placeMark.geoPoint.latitude,
                  placeMark.geoPoint.longitude,
                ),
              }
            ]),
          },
        )
        ..set(
          _firebaseFirestore
              .collection(FirebaseCollections.userLocation)
              .doc(placeMark.country)
              .collection(placeMark.state)
              .doc(placeMark.state),
          {
            'district': FieldValue.arrayUnion([
              {
                placeMark.district: GeoPoint(
                  placeMark.geoPoint.latitude,
                  placeMark.geoPoint.longitude,
                ),
              }
            ]),
          },
        )
        ..set(
          _firebaseFirestore
              .collection(FirebaseCollections.userLocation)
              .doc(placeMark.country)
              .collection(placeMark.state)
              .doc(placeMark.state)
              .collection(placeMark.district)
              .doc(placeMark.district),
          {
            'localArea': FieldValue.arrayUnion([
              {
                placeMark.localArea: GeoPoint(
                  placeMark.geoPoint.latitude,
                  placeMark.geoPoint.longitude,
                ),
              }
            ]),
          },
        );

      await batch.commit();
      return right(unit); // stop and set location
    } on FirebaseException catch (e) {
      return left(
        MainFailure.firebaseException(
          errMsg: e.code,
        ),
      );
    } catch (e) {
      return left(
        MainFailure.firebaseException(
          errMsg: '$e',
        ),
      );
    }
  }

  @override
  FutureResult<List<PlaceMark>?> getSearchPlaces(String query) async {
    try {
      final getPlaces = await OpenStritMapServices.searchPlaces(input: query);
      return right(getPlaces);
    } catch (ex) {
      return left(MainFailure.locationError(errMsg: ex.toString()));
    }
  }

  @override
  Future<Either<MainFailure, Unit>> updateUserLocation(
      PlaceMark placeMark, String userId) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .update({'placemark': placeMark.toMap()});
      return right(unit);
    } catch (e) {
      return left(MainFailure.locationError(errMsg: e.toString()));
    }
  }
}
