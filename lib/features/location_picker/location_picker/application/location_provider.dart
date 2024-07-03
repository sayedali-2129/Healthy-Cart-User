import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/i_location_facde.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
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
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<bool> getLocationPermisson() async {
    locationGetLoading = true;
    notifyListeners();
    await iLocationFacade.getLocationPermisson();
    locationGetLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> getCurrentLocationAddress() async {
    searchLoading = true;
    locationGetLoading = true;
    final result = await iLocationFacade.getCurrentLocationAddress();
    result.fold((error) {
       locationGetLoading = false; // this is the loading in the on the initial page
      log("ERROR IN CURRENT LOCATION:$error");
      //  CustomToast.errorToast(text: error.errMsg);
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
      log("ERROR IN Search LOCATION:$error");
      CustomToast.errorToast(text: error.errMsg);
      searchLoading = false;
      notifyListeners();
    }, (placeList) {
      searchResults = placeList ?? [];
      searchLoading = false;
      notifyListeners();
    });
  }

  Future<void> setLocationByUser({
    required BuildContext context,
    required bool isUserEditProfile,
  }) async {
    log('Location selected::::$selectedPlaceMark');
    final result = await iLocationFacade.setLocationByUser(selectedPlaceMark!);
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
    }, (sucess) async {
      log('$userId');
      final result = await iLocationFacade.updateUserLocation(
          selectedPlaceMark!, userId ?? '');
      result.fold((failure) {
        Navigator.pop(context);
        CustomToast.errorToast(
            text: "Can't able to add location, please try again");
      }, (sucess) {
        log(isUserEditProfile.toString());
        Navigator.pop(context);
        CustomToast.sucessToast(text: 'Location added sucessfully');
        (isUserEditProfile)
            ? EasyNavigation.pop(context: context)
            : EasyNavigation.pushAndRemoveUntil(
                context: context, page: const SplashScreen());
          locationGetLoading = false; /// here the get location on the initial location pick ends        
        notifyListeners();
      });
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
  PlaceMark? localsavedplacemark;
  Future<void> clearLocationLocally() async {
    await iLocationFacade.clearLocation();
  }

  Future<PlaceMark?> getLocationLocally() async {
    locallysavedplacemark = await iLocationFacade.getLocationLocally();
    localsavedplacemark = locallysavedplacemark;
    return locallysavedplacemark;
    // log('$locallysavedplacemark');
  }

  Future<void> saveLocationLocally(PlaceMark placeMark) async {
    iLocationFacade.saveLocationLocally(placeMark);
    localsavedplacemark = placeMark;
    notifyListeners();
  }
}
