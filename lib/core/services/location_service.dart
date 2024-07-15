import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  static const String _locationKey = 'user-location';

  Future<bool> getLocationPermission() async {
    bool isServiceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      // Request to enable location services
      permission = await Geolocator.requestPermission();
    }

    // Check the current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      // Request permission
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        // Handle permission denied scenario
        return false;
      }
    }

    // If permission is granted, handle fetching location accordingly
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    }

    return true;
  }

  Future<Either<MainFailure, Placemark>> getCurrentLocationAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark>? place = await GeocodingPlatform.instance
        ?.placemarkFromCoordinates(position.latitude, position.longitude);
    if (place == null) {
      return left(
          const MainFailure.locationError(errMsg: 'Location not found'));
    }
    return right(place.first);
  }

  Future<void> saveLocationLocally(PlaceMark placeMark) async {
    final prefs = await SharedPreferences.getInstance();
    final placeMarkJson = placeMark.toJson();

    await prefs.setString(_locationKey, placeMarkJson);
  }

  Future<PlaceMark?> getLocationLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final placeMarkJson = prefs.getString(_locationKey);
    if (placeMarkJson != null) {
      return PlaceMark.fromJson(placeMarkJson);
    }
    return null;
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationKey);
  }
}
