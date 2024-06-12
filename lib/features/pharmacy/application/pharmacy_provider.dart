import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_user_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_cart_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class PharmacyProvider extends ChangeNotifier {
  PharmacyProvider(this._iPharmacyFacade);
  final IPharmacyFacade _iPharmacyFacade;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  List<PharmacyModel> pharmacyList = [];
  bool fetchLoading = false;
  List<PharmacyCategoryModel> pharmacyCategoryList = [];
  List<String> pharmacyCategoryIdList = [];
  List<String> bannerImageList = [];
  List<PharmacyProductAddModel> productCategoryWiseList = [];
  List<PharmacyProductAddModel> productAllList = [];
  PharmacyModel? selectedpharmacyData;
  String? categoryId;
  String? selectedCategory;
  String? pharmacyId;
  List<String> productImageUrlList = [];
  bool bottomsheetCart = false;
  final TextEditingController searchController = TextEditingController();

/* --------------------------------- common --------------------------------- */
  void setPharmacyIdAndCategoryList(
      {required String selectedpharmacyId,
      required List<String> categoryIdList,
      required PharmacyModel pharmacy}) {
    pharmacyCategoryIdList = categoryIdList;
    pharmacyId = selectedpharmacyId;
    selectedpharmacyData = pharmacy;
    notifyListeners();
  }

  int selectedIndex = 0;
  void selectedImageIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void setProductImageList(List<String> productImageList) {
    productImageUrlList = productImageList;
    notifyListeners();
  }

  void bottomsheetSwitch(bool value) {
    bottomsheetCart = value;
    notifyListeners();
  }

  String expiryDateSetterFetched(Timestamp expiryDate) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(expiryDate.millisecondsSinceEpoch);
    final String result = DateFormat('yyyy-MM').format(date);
    return result;
  }
  /* -------------------------------------------------------------------------- */
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

/* --------------------------- Get Pharmacy Banner -------------------------- */

  Future<void> getBanner() async {
    bannerImageList.clear(); // clearing banner list here
    fetchLoading = true;
    notifyListeners();
    final result =
        await _iPharmacyFacade.getPharmacyBanner(pharmacyId: pharmacyId ?? '');
    result.fold((failure) {
      fetchLoading = false;
      notifyListeners();
      CustomToast.errorToast(text: "Couldn't able to get pharmacy banner");
    }, (bannerlist) {
      for (var banner in bannerlist) {
        bannerImageList.add(banner.image ?? '');
      }
      fetchLoading = false;
      notifyListeners();
    });
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
      fetchLoading = false;
      notifyListeners();
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
      fetchLoading = false;
      notifyListeners();
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

  /* -------------------------------------------------------------------------- */

  /* ------------------------------ cart section ------------------------------ */

  List<String> productIdList = [];
  List<int> countOfProduct = [];
  int quantityCount = 1;
  Map<String, dynamic> cartProductMap = {};
  Map<String, int> productCartData = {};
  List<int> productCartQuantityList = [];
  List<String> productCartIdList = [];
  List<PharmacyProductAddModel> pharmacyCartProducts = [];
  List<ProductAndQuantityModel> productAndQuantityDetails = [];
  PharmacyCartModel? orderProducts;
  PharmacyCartModel? orderProductsAdded;
  UserAddressModel? userAddress;

  void increment() {
    quantityCount++;
    notifyListeners();
  }

  void decrement() {
    if (quantityCount <= 1) return;
    quantityCount--;
    notifyListeners();
  }

  Future<void> createOrGetProductToUserCart() async {
    // fetchLoading = true;
    // notifyListeners();
    final result = await _iPharmacyFacade.createOrGetProductToUserCart(
      pharmacyId: pharmacyId!,
      userId: userId!,
    );
    result.fold(
      (failure) {
        CustomToast.errorToast(text: "Something went wrong");
      },
      (cartProductsData) {
        if (cartProductsData.isNotEmpty) {
          cartProductsData.forEach(
            (key, value) {
              productCartQuantityList.add(value);
              productCartIdList.add(key);
            },
          );
          cartProductMap.addAll(cartProductsData);
        }
      },
    );
  }

  Future<void> getpharmcyCartProduct() async {
    if (pharmacyCartProducts.isNotEmpty) return;
     fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getpharmcyCartProduct(
        productCartIdList: productCartIdList);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to fetch categories");
      fetchLoading = false;
      notifyListeners();
    }, (castProductList) {
      pharmacyCartProducts.addAll(castProductList);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearCartData() {
    pharmacyCartProducts.clear();
    productCartIdList.clear();
    productCartQuantityList.clear();
    cartProductMap.clear();
    notifyListeners();
  }

  Future<void> addProductToUserCart({required String productId}) async {
    productCartData = {productId: quantityCount};

    final result = await _iPharmacyFacade.addProductToUserCart(
        cartProduct: productCartData, pharmacyId: pharmacyId!, userId: userId!);
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
      },
      (productData) {
        productCartData = productData;
        if (productCartData.isNotEmpty) {
          productCartData.forEach(
            (key, value) {
              productCartQuantityList.add(value);
              productCartIdList.add(key);
            },
          );
        }
        CustomToast.sucessToast(text: "Added to cart");
        bottomsheetSwitch(true);
        notifyListeners();
      },
    );
  }

  Future<void> createProductOrderDetails({String? productId}) async {
    cartProductsDetails();
    final result = await _iPharmacyFacade.createProductOrderDetails(
        orderProducts: orderProducts!, productId: productId);
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
      },
      (orderProduct) {
        orderProductsAdded = orderProduct;
        CustomToast.sucessToast(text: "Added to cart");
        notifyListeners();
      },
    );
  }

  void cartProductsDetails() {
    orderProducts = PharmacyCartModel(
      pharmacyId: pharmacyId,
      userId: userId,
      productId: productIdList,
      productDetails: productAndQuantityDetails,
      orderStatus: 0,
      addresss: userAddress ?? UserAddressModel(),
      createdAt: Timestamp.now(),
    );
  }

  String? selectedCartProductId;
  void setCartProductId(String id) {
    selectedCartProductId = id;
  }

  void productDetailsPage( // call in add to cart place
      {
    required int quantity,
    required PharmacyProductAddModel productToCartDetails,
  }) {
    final value = ProductAndQuantityModel(
        createdAt: Timestamp.now(),
        quantity: quantity,
        productId: selectedCartProductId,
        productData: productToCartDetails);

    productIdList.add(productToCartDetails.id ?? '');
    productAndQuantityDetails.add(value);
  }

  void setDeliveryAddress({required UserAddressModel address}) {
    userAddress = address;
  }
}
