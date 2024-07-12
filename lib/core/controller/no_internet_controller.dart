import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_internet.dart';

class NoInternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    _connectivity.onConnectivityChanged.listen(updateConnectivityPage);
    super.onInit();
  }

  void updateConnectivityPage(List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.first == ConnectivityResult.none) {
      Get.to(const NoInternetPage());
    } else {
      Get.back();
    }
  }
}

class DependencyInjection {
  static void init() {
    Get.put<NoInternetController>(NoInternetController(), permanent: true);
  }
}
