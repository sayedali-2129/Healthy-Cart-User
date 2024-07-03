import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/core/services/send_fcm_message.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class PharmacyProvider extends ChangeNotifier {
  PharmacyProvider(this._iPharmacyFacade);
  final IPharmacyFacade _iPharmacyFacade;
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
  String? userId = FirebaseAuth.instance.currentUser?.uid;

/* ---------------------------------- prescription image --------------------------------- */
  String? prescriptionImageUrl;
  File? prescriptionImageFile;
  Future<void> getImage({required ImageSource imagesource}) async {
    final result = await _iPharmacyFacade.getImage(imagesource: imagesource);
    notifyListeners();
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
    }, (imageFilesucess) async {
      prescriptionImageFile = imageFilesucess;
      notifyListeners();
    });
  }

  Future<void> saveImage() async {
    if (prescriptionImageFile == null) {
      return;
    }
    fetchLoading = true;

    /// fetch loading is true because I am using this function along with add function
    notifyListeners();
    final result =
        await _iPharmacyFacade.saveImage(imageFile: prescriptionImageFile!);
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
    }, (imageurlGet) {
      prescriptionImageUrl = imageurlGet;
      notifyListeners();
    });
  }

  void clearImageFile() {
    prescriptionImageFile = null;
    notifyListeners();
  }

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
  Map<String, int> productCartDataAdded = {};
  List<int> productCartQuantityList = [];
  List<String> productCartIdList = [];
  List<PharmacyProductAddModel> pharmacyCartProducts = [];
  List<ProductAndQuantityModel> productAndQuantityDetails = [];
  PharmacyOrderModel? orderProducts;
  PharmacyOrderModel? orderProductsAdded;
  UserAddressModel? userAddress;
  UserModel? userDetails;
  num totalAmount = 0;
  num totalFinalAmount = 0;
  // increment of the quantity from product details page
  void increment() {
    quantityCount++;
    notifyListeners();
  }

  // decrement of the quantity from product details page
  void decrement() {
    if (quantityCount <= 1) return;
    quantityCount--;
    notifyListeners();
  }

  // increment of the quantity from product cart page
  void incrementInCart(
      {required int index,
      required num productMRPRate,
      required num productDiscountRate}) {
    productCartQuantityList[index]++;
    totalFinalAmount += productDiscountRate;
    totalAmount += productMRPRate;
    notifyListeners();
  }

  // decrement of the quantity from product cart page
  void decrementInCart(
      {required int index,
      required num productMRPRate,
      required num productDiscountRate}) {
    if (productCartQuantityList[index] <= 1) {
      return CustomToast.infoToast(
          text:
              "If you want to remove the product please remove from the cart.");
    }
    productCartQuantityList[index]--;
    totalFinalAmount -= productDiscountRate;
    totalAmount -= productMRPRate;
    notifyListeners();
  }

// creating a cart or getting the product cart id and quantity from user document
  Future<void> createOrGetProductToUserCart() async {
    fetchLoading = true;
    final result = await _iPharmacyFacade.createOrGetProductToUserCart(
      pharmacyId: pharmacyId!,
      userId: userId!,
    );
    result.fold(
      (failure) {
        CustomToast.errorToast(text: "Something went wrong");
        fetchLoading = false;
        notifyListeners();
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
        fetchLoading = false;
        notifyListeners();
      },
    );
  }

// getting cart full product details from user pharmacy
  Future<void> getpharmcyCartProduct() async {
    pharmacyCartProducts.clear();
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getpharmcyCartProduct(
        productCartIdList: productCartIdList);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to fetch categories");
      fetchLoading = false;
      notifyListeners();
    }, (cartProductList) {
      pharmacyCartProducts.addAll(cartProductList);
      fetchLoading = false;
      notifyListeners();
    });
  }

  void clearCartData() {
    pharmacyCartProducts.clear();
    productCartIdList.clear();
    productCartQuantityList.clear();
    cartProductMap.clear();
    notifyListeners();
  }

// adding pharmacy cart in
  Future<void> addProductToUserCart(
      {required String productId,
      required int selectedQuantityCount,
      required bool? cartQuantityIncrement}) async {
    productCartDataAdded = {productId: selectedQuantityCount};

    final result = await _iPharmacyFacade.addProductToUserCart(
        cartProduct: productCartDataAdded,
        pharmacyId: pharmacyId ?? '',
        userId: userId ?? '');
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
      },
      (productData) {
        productCartDataAdded = productData;
        if (productCartDataAdded.isNotEmpty) {
          productCartDataAdded.forEach(
            (key, value) {
              productCartQuantityList.add(value);
              productCartIdList.add(key);
            },
          );
        } // here when the prodct is incremented from the cart it will show the toast accordingly
        if (cartQuantityIncrement == true) {
          CustomToast.sucessToast(text: "One quantity added.");
        } else if (cartQuantityIncrement == false) {
          CustomToast.sucessToast(text: "One quantity removed.");
        } else {
          CustomToast.sucessToast(text: "Product added to cart.");
        }
        bottomsheetSwitch(true);
        notifyListeners();
      },
    );
  }

  Future<void> removeProductFromUserCart({
    required PharmacyProductAddModel productData,
    required int index,
  }) async {
    final result = await _iPharmacyFacade.removeProductFromUserCart(
        cartProductId: productData.id ?? '',
        pharmacyId: pharmacyId ?? '',
        userId: userId ?? '');
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
      },
      (sucess) {
        pharmacyCartProducts.removeAt(index);
        totalAmount -= productData.productMRPRate!;
        if (productData.productDiscountRate != null) {
          totalFinalAmount -= productData.productDiscountRate!;
        } else {
          totalFinalAmount -= productData.productMRPRate!;
        }
        cartProductMap.remove(productData.id);
        productCartQuantityList.removeAt(index);
        productCartIdList.removeAt(index);
        notifyListeners();
        CustomToast.sucessToast(text: 'Removed sucessfully');
      },
    );
  }

/* ---------------------------- PRICE CALCULATOR ---------------------------- */
  void totalAmountCalclator() {
    totalAmount = 0;
    totalFinalAmount = 0;
    num totalDiscountAmount = 0;
    num totalMRPAmount = 0;

    for (int i = 0; i < pharmacyCartProducts.length; i++) {
      if (pharmacyCartProducts[i].productDiscountRate == null) {
        totalDiscountAmount = productCartQuantityList[i] *
            pharmacyCartProducts[i].productMRPRate!;
      } else {
        totalDiscountAmount = productCartQuantityList[i] *
            pharmacyCartProducts[i].productDiscountRate!;
      }
      totalMRPAmount =
          productCartQuantityList[i] * pharmacyCartProducts[i].productMRPRate!;

      totalAmount += totalMRPAmount;
      totalFinalAmount += totalDiscountAmount;
    }

    log("totalAmount  :$totalAmount");

    notifyListeners();
  }
/* -------------------------------------------------------------------------- */

/* ------------------------------ RADIO BUTTON ------------------------------ */
String? selectedRadio;

  setSelectedRadio(String? value) {
    selectedRadio = value;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
/* -------------------------- ORDER CREATE SECTION -------------------------- */
  Future<void> createProductOrderDetails({
    required BuildContext context,
  }) async {
    cartProductsDetails();
    final result = await _iPharmacyFacade.createProductOrderDetails(
      pharmacyId: pharmacyId ?? '',
      userId: userId ?? '',
      orderProducts: orderProducts!,
    );
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
        EasyNavigation.pop(context: context);
      },
      (orderProduct) {
        orderProductsAdded = orderProduct;
        notifyListeners();
        clearImageFile();
        EasyNavigation.pop(context: context);
        EasyNavigation.push(
            context: context,
            page: const OrderRequestSuccessScreen(
              title: 'Your order is in review, we will notify you soon.',
            ));
        sendFcmMessage(
            token: selectedpharmacyData?.fcmToken ?? '',
            body:
                'New Order Received from ${userDetails?.userName ?? 'Customer'}. Please check the details and accept the order',
            title: 'New Booking Received!!!');
        log('Order Request Send Successfully');
        CustomToast.sucessToast(text: "The order is in review");
        clearProductAndUserInCheckOutDetails();
      },
    );
  }

  void cartProductsDetails() {
    orderProducts = PharmacyOrderModel(
      pharmacyId: pharmacyId,
      userId: userId,
      userDetails: userDetails,
      addresss: userAddress,
      productId: productIdList,
      productDetails: productAndQuantityDetails.toList(),
      orderStatus: 0,
      paymentStatus: 0,
      pharmacyDetails: selectedpharmacyData,
      deliveryType: selectedRadio,
      totalDiscountAmount: totalFinalAmount,
      totalAmount: totalAmount,
      createdAt: Timestamp.now(),
      prescription:
          (prescriptionImageUrl != null) ? prescriptionImageUrl : null,
    );
  }

  bool cartContainsOutOfStockProduct() {
    for (var element in pharmacyCartProducts) {
      if (element.inStock == false) {
        return true;
      }
    }
    return false;
  }

  void productDetails({
    required int quantity,
    required PharmacyProductAddModel productToCartDetails,
    required String id, // call in add to cart place
  }) {
    final value = ProductAndQuantityModel(
      quantity: quantity,
      productId: id,
      productData: productToCartDetails,
    );

    productIdList.add(id);
    productAndQuantityDetails.add(value);
  }

  void clearProductAndUserInCheckOutDetails() {
    log('Calledd clear selectedRadoi');
    userAddress = null;
    userDetails = null;
    selectedRadio = null;
    prescriptionImageUrl = null;
    prescriptionImageFile = null;
    productIdList.clear();
    productAndQuantityDetails.clear();
  }

  void setDeliveryAddressAndUserData({
    required UserAddressModel? address,
    required UserModel userData,
  }) {
    userAddress = address;
    userDetails = userData;
  }

  /* -------------------------------------------------------------------------- */
}
