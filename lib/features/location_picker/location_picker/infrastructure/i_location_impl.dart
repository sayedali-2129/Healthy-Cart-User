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
    return await _locationService.getLocationPermission();
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

  /* ----------------------- LOCALLY SAVING THE ADDRESS ----------------------- */
  @override
  Future<void> clearLocation() async {
    await _locationService.clearLocation();
  }

  @override
  Future<PlaceMark?> getLocationLocally() async {
    final result = await _locationService.getLocationLocally();
    return result;
  }

  @override
  Future<void> saveLocationLocally(PlaceMark placeMark) async {
    await _locationService.saveLocationLocally(placeMark);
  }
}
