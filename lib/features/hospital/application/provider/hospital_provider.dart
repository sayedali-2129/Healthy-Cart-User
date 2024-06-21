import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/hospital/domain/facade/i_hospital_facade.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_banner_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HospitalProvider with ChangeNotifier {
  HospitalProvider(this.iHospitalFacade);
  final IHospitalFacade iHospitalFacade;

  TextEditingController hospitalSearch = TextEditingController();

  List<HospitalModel> hospitalList = [];
  List<HospitalBannerModel> hospitalBanner = [];

  bool hospitalFetchLoading = false;
  bool isLoading = true;

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
}
