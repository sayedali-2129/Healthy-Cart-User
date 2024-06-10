import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_banner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class PharmacyProvider extends ChangeNotifier {
  PharmacyProvider(this._iPharmacyFacade);
  final IPharmacyFacade _iPharmacyFacade;
  List<PharmacyModel> pharmacyList = [];
  bool fetchLoading = false;
  List<PharmacyCategoryModel> pharmacyCategoryList = [];
  List<String> pharmacyCategoryIdList = [];
  List<PharmacyBannerModel> bannerList = [];
  List<PharmacyProductAddModel> productCategoryWiseList = [];
  List<PharmacyProductAddModel> productAllList = [];
  PharmacyModel? selectedpharmacyData;
  String? categoryId;
  String? selectedCategory;
  String? pharmacyId;
  final TextEditingController searchController = TextEditingController();

  void setPharmacyIdAndCategoryList(
      {required String selectedpharmacyId,
      required List<String> categoryIdList,
      required PharmacyModel pharmacy}) {
    pharmacyCategoryIdList = categoryIdList;
    pharmacyId = selectedpharmacyId;
    selectedpharmacyData = pharmacy;
    notifyListeners();
  }
/* ---------------------------- Get All Pharmacy ---------------------------- */

  Future<void> getAllPharmacy({String? searchText}) async {
    fetchLoading = true;
    notifyListeners();
    final result =
        await _iPharmacyFacade.getAllPharmacy(searchText: searchText);
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to show pharmacies near you.");
    }, (pharmacies) {
      pharmacyList.addAll(pharmacies); //// here we are assigning pharmecies
    });
    fetchLoading = false;
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */

/* --------------------------- Get Pharmacy Banner -------------------------- */

  Future<void> getBanner() async {
    if (bannerList.isNotEmpty) return;
    fetchLoading = true;
    notifyListeners();
    final result =
        await _iPharmacyFacade.getPharmacyBanner(pharmacyId: pharmacyId ?? '');
    result.fold((failure) {
      log(failure.errMsg);
      CustomToast.errorToast(text: "Couldn't able to get pharmacy banner");
    }, (bannerlist) {
      bannerList.addAll(bannerlist);
      fetchLoading = false;
      notifyListeners();
    });
  }

  void clearPharmacyFetchData() {
    searchController.clear();
    pharmacyList.clear();
    _iPharmacyFacade.clearPharmacyFetchData();
  }

  void searchPharmacy({
    required String searchText,
  }) {
    _iPharmacyFacade.clearPharmacyFetchData();
    pharmacyList.clear();
    getAllPharmacy(searchText: searchText);
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */

/* -------------------------- Get Pharmacy Product -------------------------- */

  Future<void> getPharmacyAllProductDetails({
    String? searchText,
  }) async {
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getPharmacyAllProductDetails(
        pharmacyId: pharmacyId, searchText: searchText);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to show products");
    }, (products) {
      productAllList.addAll(products); //// here we are assigning the doctor
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearPharmacyAllProductFetchData() {
    productAllList.clear();
    searchController.clear();
    _iPharmacyFacade.clearPharmacyAllProductFetchData();
  }

  void searchAllProduct({
    required String searchText,
  }) {
    _iPharmacyFacade.clearPharmacyAllProductFetchData();
    productAllList.clear();
    getPharmacyAllProductDetails(searchText: searchText);
    notifyListeners();
  }

  void setCategoryId(
      {required String selectedCategoryId,
      required String selectedCategoryName}) {
    categoryId = selectedCategoryId;
    selectedCategory = selectedCategoryName;
    notifyListeners();
  }

  Future<void> getPharmacyCategoryProductDetails({
    String? searchText,
  }) async {
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getPharmacyCategoryProductDetails(
        categoryId: categoryId, pharmacyId: pharmacyId, searchText: searchText);
    log(categoryId.toString());
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to show products");
    }, (products) {
      productCategoryWiseList.addAll(
          products); //// here we are assigning the category wise product
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearPharmacyCategoryProductFetchData() {
    productCategoryWiseList.clear();
    searchController.clear();
    _iPharmacyFacade.clearPharmacyCategoryProductFetchData();
  }

  void searchCategoryWiseProduct({
    required String searchText,
  }) {
    _iPharmacyFacade.clearPharmacyCategoryProductFetchData();
    productCategoryWiseList.clear();
    getPharmacyCategoryProductDetails(searchText: searchText);
    notifyListeners();
  }
/* -------------------------------------------------------------------------- */

/* ------------------------------ get category ------------------------------ */

  Future<void> getpharmacyCategory() async {
    fetchLoading = true;
    pharmacyCategoryList.clear();
    notifyListeners();
    final result = await _iPharmacyFacade.getpharmacyCategory(
        categoryIdList: pharmacyCategoryIdList);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to fetch category");
      fetchLoading = false;
      notifyListeners();
    }, (categoryList) {
      pharmacyCategoryList.addAll(categoryList);
    });
    fetchLoading = false;
    notifyListeners();
  }
}
