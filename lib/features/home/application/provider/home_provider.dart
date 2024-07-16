import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/home/domain/facade/i_home_facade.dart';
import 'package:healthy_cart_user/features/home/domain/models/home_banner_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class HomeProvider with ChangeNotifier {
  HomeProvider(this.iHomeFacade);
  final IHomeFacade iHomeFacade;

  List<HomeBannerModel> homeBannerList = [];

  bool isLoading = true;

  DateTime? currentBackPressTime;
  int requiredSeconds = 2;
  bool canPopNow = false;
/* ---------------------------- FETCH HOME BANNER --------------------------- */
  Future<void> getBanner() async {
    if (homeBannerList.isNotEmpty) return;
    isLoading = true;
    notifyListeners();
    final result = await iHomeFacade.getBanner();
    result.fold(
      (err) {
        // log("'ERROR IN PROVIDER getBanner(): ${err.errMsg}");
      },
      (success) {
        homeBannerList = success;
      },
    );
    isLoading = false;
    notifyListeners();
  }

/* ------------------------------ EXIT FROM APP ----------------------------- */
  void onPopInvoked(bool didPop) {
    DateTime currentTime = DateTime.now();
    if (currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      currentBackPressTime = currentTime;
      CustomToast.infoToast(text: 'Press again to exit');
      Future.delayed(
        Duration(seconds: requiredSeconds),
        () {
          canPopNow = false;
          notifyListeners();
        },
      );

      canPopNow = true;
      notifyListeners();
    }
  }

  Future<bool> installedFirtTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool isFirstTime = preferences.getBool('firstTime') ?? true;

    if (isFirstTime == true) {
      await preferences.setBool('firstTime', false);
    }
    return isFirstTime;
  }
}
