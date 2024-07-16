import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/i_location_facde.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationProvider extends ChangeNotifier {
  LocationProvider(this.iLocationFacade);
  bool locationGetLoading = false;
  final ILocationFacade iLocationFacade;
  PlaceMark? selectedPlaceMark;
  final searchController = TextEditingController();

  List<PlaceMark> searchResults = [];
  bool searchLoading = false;
  String? userId;
  void setUserId(String? id) {
    userId = id;
  }

  Future<bool> getLocationPermisson() async {
    locationGetLoading = true;
    notifyListeners();
    bool? isPermissionEnabled;
    await iLocationFacade.getLocationPermisson().then(
      (value) {
        isPermissionEnabled = value;
        locationGetLoading = false;
        notifyListeners();
      },
    );
    return isPermissionEnabled!;
  }

  Future<void> getCurrentLocationAddress() async {
    searchLoading = true;
    locationGetLoading = true;
    final result = await iLocationFacade.getCurrentLocationAddress();
    result.fold((error) {
      locationGetLoading =
          false; // this is the loading in the on the initial page

      searchLoading = false;
    }, (placeMark) {
      selectedPlaceMark = placeMark;
      searchLoading = false;
      notifyListeners();
    });
  }

  Future<void> searchPlaces() async {
    searchLoading = true;
    notifyListeners();
    final result = await iLocationFacade.getSearchPlaces(searchController.text);
    result.fold((error) {
      CustomToast.errorToast(text: error.errMsg);
      searchLoading = false;
      notifyListeners();
    }, (placeList) {
      searchResults = placeList ?? [];
      searchLoading = false;
      notifyListeners();
    });
  }

  Future<void> setLocationOfUser({
    required BuildContext context,
    required bool isUserEditProfile,
    required int locationSetter,
    required VoidCallback onSucess,
  }) async {
    if (selectedPlaceMark == null) {
      locationGetLoading = false;
      notifyListeners();
      CustomToast.errorToast(text: "Couldn't able to get the location,please try again");
      return;
    }
    locationGetLoading = true;
    notifyListeners();

    final result = await iLocationFacade.updateUserLocation(selectedPlaceMark!, userId ?? '');
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
      locationGetLoading = false;
      notifyListeners();
    }, (sucess) {
      saveLocationLocally(
              isUserEditProfile: isUserEditProfile,
              context: context,
              locationSetter: locationSetter,
              onSucess: onSucess)
          .whenComplete(
        () {
          locationGetLoading = false;
          notifyListeners();
        },
      );

      /// here the get location on the initial location pick ends
    });
  }

  void setSelectedPlaceMark(PlaceMark place) {
    selectedPlaceMark = place;
    notifyListeners();
  }

  void clearLocationData() {
    selectedPlaceMark = null;
    searchResults.clear();
    searchController.clear();
    notifyListeners();
  }

/* ------------------------- Locally saved location ------------------------- */
  PlaceMark? locallysavedplacemark;
  PlaceMark? localsavedHomeplacemark;
  PlaceMark? locallySavedHospitalplacemark;
  PlaceMark? locallySavedPharmacyplacemark;
  PlaceMark? locallySavedLabortaryplacemark;
  PlaceMark? locallySavedDoctorplacemark;
  Future<void> clearLocationLocally() async {
    await iLocationFacade.clearLocation();
  }

  Future<PlaceMark?> getLocationLocally() async {
    locallysavedplacemark = await iLocationFacade.getLocationLocally();
    return locallysavedplacemark;
  }

  Future<void> saveLocationLocally({
    required bool isUserEditProfile,
    required BuildContext context,
    required int locationSetter,
    required VoidCallback onSucess,
  }) async {
    if (selectedPlaceMark == null) {
      locationGetLoading = false;
      notifyListeners();
      CustomToast.errorToast(
          text: "Couldn't able to get the location,please try again");
      return;
    }
    locationGetLoading = true;
    notifyListeners();
    await iLocationFacade.saveLocationLocally(selectedPlaceMark!).whenComplete(
      () {
        if (locationSetter == 1) {
          locallySavedHospitalplacemark = selectedPlaceMark;
          notifyListeners();
        } else if (locationSetter == 2) {
          locallySavedLabortaryplacemark = selectedPlaceMark;

          notifyListeners();
        } else if (locationSetter == 3) {
          locallySavedPharmacyplacemark = selectedPlaceMark;
          notifyListeners();
        } else if (locationSetter == 4) {
          localsavedHomeplacemark = selectedPlaceMark;
          notifyListeners();
        } else if (locationSetter == 5) {
          locallySavedDoctorplacemark = selectedPlaceMark;
        } else {
          locallySavedHospitalplacemark = selectedPlaceMark;
          locallySavedLabortaryplacemark = selectedPlaceMark;
          locallySavedPharmacyplacemark = selectedPlaceMark;
          localsavedHomeplacemark = selectedPlaceMark;
          locallySavedDoctorplacemark = selectedPlaceMark;
        }
        onSucess.call();
        locationGetLoading = false;
        CustomToast.sucessToast(text: 'Location added sucessfully');
        notifyListeners();
      },
    );
  }
}
