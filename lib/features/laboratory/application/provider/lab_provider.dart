import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_orders_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_banner_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_test_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class LabProvider with ChangeNotifier {
  LabProvider(this.iLabFacade, this.iLabOrdersFacade);
  final ILabFacade iLabFacade;
  final ILabOrdersFacade iLabOrdersFacade;

  bool isLabOnlySelected = true;
  TextEditingController labSearchController = TextEditingController();

  List<LabModel> labList = [];
  List<LabBannerModel> labBannerList = [];
  List<LabTestModel> testList = [];
  List<LabTestModel> doorStepTestList = [];
  Set<String> labIds = {};
  bool detailsScreenLoading = true;
  bool labFetchLoading = false;
  bool isTestSelected = false;
  // bool bannerFetching = false;
  // bool testFetching = false;
  List<String> selectedTestIds = [];

  List<LabTestModel> cartItems = [];

  bool isBottomContainerPopUp = false;
  bool selectedTestType = false;

/* ------------------------ CHECK OUT CONTAINER POPUP ----------------------- */
  void bottomPopUpContainer() {
    if (selectedTestIds.isNotEmpty) {
      isBottomContainerPopUp = true;
    } else if (selectedTestIds.isEmpty) {
      isBottomContainerPopUp = false;
    }
    notifyListeners();
  }

/* ----------------------------- TEST SELECTION ----------------------------- */
  void labTabSelection() {
    isLabOnlySelected = !isLabOnlySelected;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /* -------------------------- PAYMENT SUCCESS SOUND ------------------------- */
  Future<void> playPaymentSound() async {
    await iLabFacade.playPaymentSound();
  }
  /* -------------------------------------------------------------------------- */

/* --------------------------- GET AND SEARCH LABS -------------------------- */
  Future<void> getLabs() async {
    labFetchLoading = true;
    notifyListeners();

    final result =
        await iLabFacade.getLabs(labSearch: labSearchController.text);

    result.fold(
      (err) {
        log(err.errMsg);
        labFetchLoading = false;
        notifyListeners();
      },
      (success) {
        final uniqueLabs = success
            .where(
              (labs) => !labIds.contains(labs.id),
            )
            .toList();
        labIds.addAll(uniqueLabs.map(
          (labs) => labs.id!,
        ));
        labList.addAll(uniqueLabs);
        notifyListeners();
        log('labs fetched successfully');
      },
    );
    labFetchLoading = false;
    notifyListeners();
  }

  void searchLabs() {
    clearLabData();
    getLabs();
    notifyListeners();
  }

  void clearLabData() {
    iLabFacade.clearData();
    labIds.clear();
    labList = [];
    notifyListeners();
  }

  void init(ScrollController scrollController) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            labFetchLoading == false) {
          getLabs();
        }
      },
    );
  }
  /* -------------------------------------------------------------------------- */

  /* ----------------------------- GET LAB BANNER ----------------------------- */
  Future<void> getLabBanner({required String labId}) async {
    // detailsScreenLoading = true;
    labBannerList.clear();
    notifyListeners();
    final result = await iLabFacade.getLabBanner(labId: labId);
    result.fold(
      (err) {
        log('error in banner fetch :: ${err.errMsg}');
        detailsScreenLoading = false;
        notifyListeners();
      },
      (bannerList) {
        labBannerList = bannerList;
        log('banner fetched :: $labId');
        detailsScreenLoading = false;
        notifyListeners();
      },
    );
  }

  /* ------------------------------ GET LAB TESTS ----------------------------- */
  Future<void> getAllTests({required String labId}) async {
    // detailsScreenLoading = true;
    testList.clear();
    notifyListeners();
    final result = await iLabFacade.getAvailableTests(labId: labId);
    result.fold(
      (err) {
        log('error in getAllTests() :: ${err.errMsg}');
        detailsScreenLoading = false;
        notifyListeners();
      },
      (success) {
        testList = success;
        doorStepTestList = success
            .where((element) => element.isDoorstepAvailable == true)
            .toList();
        detailsScreenLoading = false;
        notifyListeners();
      },
    );
  }

/* ------------------------- TEST ADD TO CART AND REMOVE BUTTON FUNCTIONS ------------------------ */
  void testAddButton(String testId, LabTestModel test) {
    if (selectedTestIds.contains(testId)) {
      selectedTestIds.remove(testId);
      cartItems.removeWhere((item) => item.id == testId);
    } else {
      selectedTestIds.add(testId);
      cartItems.add(test);
    }
    bottomPopUpContainer();
    notifyListeners();
  }

  void removeFromCart(int index) {
    final removedTest = cartItems[index];
    selectedTestIds.remove(removedTest.id);
    cartItems.removeAt(index);
    bottomPopUpContainer();
    notifyListeners();
  }
  /* -------------------------------------------------------------------------- */

/* ----------------------- CART CALCULATION FUNCTIONS ----------------------- */
  num claculateTotalAmount() {
    num totalAmount = 0;
    for (final item in cartItems) {
      totalAmount += item.offerPrice ?? item.testPrice!;
    }

    return totalAmount;
  }

  num claculateTotalTestFee() {
    num totalTestfee = 0;
    for (final item in cartItems) {
      totalTestfee += item.testPrice!;
    }

    return totalTestfee;
  }

  num claculateTotalOfferPrice() {
    num totalOfferPrice = 0;
    for (final item in cartItems) {
      totalOfferPrice += item.offerPrice ?? 0;
    }

    return totalOfferPrice;
  }

  num totalDicount() {
    return claculateTotalAmount() - claculateTotalTestFee();
  }
  /* -------------------------------------------------------------------------- */

  void clearCart() {
    cartItems.clear();
    selectedTestIds.clear();
    bottomPopUpContainer();
    notifyListeners();
  }

  // List<String> radioList = ['Home', 'Lab'];
/* ------------------------------ RADIO BUTTON ------------------------------ */
  String? selectedRadio;

  setSelectedRadio(String? value) {
    selectedRadio = value;
    notifyListeners();
  }

  LabOrdersModel? labOrderModel;
  /* ----------------------------- ADD LAB ORDERS ----------------------------- */
  Future<void> addLabOrders(
      {required String labId,
      required String userId,
      required UserModel userModel,
      required UserAddressModel selectedAddress}) async {
    labOrderModel = LabOrdersModel(
      labId: labId,
      selectedTest: cartItems,
      userId: userId,
      userDetails: userModel,
      userAddress: selectedAddress,
      orderAt: Timestamp.now(),
      totalAmount: claculateTotalAmount(),
      orderStatus: 0,
      paymentStatus: 0,
      testMode: selectedRadio,
    );

    final result =
        await iLabOrdersFacade.createLabOrder(labOrdersModel: labOrderModel!);
    result.fold(
      (err) {
        log('error in addLabOrders() :: ${err.errMsg}');
      },
      (success) {
        log('Order Request Send Successfully');
      },
    );
    notifyListeners();
  }
}
