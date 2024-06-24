import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HospitalProvider with ChangeNotifier {
  HospitalProvider(this.iHospitalFacade);
  final IHospitalFacade iHospitalFacade;

  TextEditingController hospitalSearch = TextEditingController();

  List<HospitalModel> hospitalList = [];
  List<HospitalBannerModel> hospitalBanner = [];
  List<HospitalCategoryModel> hospitalCategoryList = [];
  List<DoctorModel> doctorsList = [];

  bool hospitalFetchLoading = false;
  bool isLoading = true;
  String? selectedSlot;

  void setTimeSlot(String selectedTimeSlot) {
    selectedSlot = selectedTimeSlot;
    log(selectedSlot!);
    notifyListeners();
  }

/* ------------------------ GET HOSPITALS AND SEARCH ------------------------ */

  Future<void> getAllHospitals() async {
    hospitalFetchLoading = true;
    notifyListeners();

    final result = await iHospitalFacade.getAllHospitals(
        hospitalSearch: hospitalSearch.text);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
      CustomToast.errorToast(text: "Couldn't able to show hospitals near you.");
    }, (success) {
      hospitalList.addAll(success);
    });
    hospitalFetchLoading = false;
    notifyListeners();
  }

  void searchHospitals() {
    clearHospitalData();
    getAllHospitals();
    notifyListeners();
  }

  void clearHospitalData() {
    iHospitalFacade.clearHospitalData();
    hospitalList = [];
    notifyListeners();
  }

  void hospitalInit(ScrollController scrollController) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            hospitalFetchLoading == false) {
          getAllHospitals();
        }
      },
    );
  }
  /* -------------------------------------------------------------------------- */

  /* -------------------------- FETCH HOSPITAL BANNER ------------------------- */
  Future<void> getHospitalBanner({required String hospitalId}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await iHospitalFacade.getHospitalBanner(hospitalId: hospitalId);
    result.fold((err) {
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      hospitalBanner = success;
    });
    isLoading = false;
    notifyListeners();
  }

  /* -------------------------- GET HOSPITAL CATEGORY ------------------------- */
  Future<void> getHospitalCategory(
      {required List<String> categoryIdList}) async {
    isLoading = true;
    hospitalCategoryList.clear();
    notifyListeners();

    final result = await iHospitalFacade.getHospitalCategory(
        categoryIdList: categoryIdList);
    result.fold((err) {
      CustomToast.errorToast(text: "Couldn't able to fetch category");
      log('ERROR IN CATEGORY :: ${err.errMsg}');
    }, (success) {
      hospitalCategoryList = success;
    });
    isLoading = false;
    notifyListeners();
  }

  /* ------------------------------- GET DOCTORS ------------------------------ */
  Future<void> getDoctors({required String hospitalId}) async {
    isLoading = true;
    notifyListeners();
    final result = await iHospitalFacade.getDoctors(hospitalId: hospitalId);

    result.fold((err) {
      CustomToast.errorToast(text: 'Unable to get doctors');
      log('ERROR IN GET DOCTOR :: ${err.errMsg}');
    }, (success) {
      doctorsList = success;
    });
    isLoading = false;
    notifyListeners();
  }
}
