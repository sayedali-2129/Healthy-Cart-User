import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthy_cart_user/features/home/domain/facade/i_home_facade.dart';
import 'package:healthy_cart_user/features/home/domain/models/home_banner_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeProvider with ChangeNotifier {
  HomeProvider(this.iHomeFacade);
  final IHomeFacade iHomeFacade;

  List<HomeBannerModel> homeBannerList = [];

  bool isLoading = true;

/* ---------------------------- FETCH HOME BANNER --------------------------- */
  Future<void> getBanner() async {
    isLoading = true;
    notifyListeners();

    final result = await iHomeFacade.getBanner();
    result.fold(
      (err) {
        log("'ERROR IN PROVIDER getBanner(): ${err.errMsg}");
      },
      (success) {
        homeBannerList = success;
      },
    );
    isLoading = false;
    notifyListeners();
  }
}
