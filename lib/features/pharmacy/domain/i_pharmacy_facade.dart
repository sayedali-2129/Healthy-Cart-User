import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/domain/model/location_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_banner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class IPharmacyFacade {

  FutureResult<File> getImage({required ImageSource imagesource});
  FutureResult<String>saveImage({
    required File imageFile,
  });

  FutureResult<List<PharmacyProductAddModel>> getPharmacyAllProductDetails({
    required String? pharmacyId,
    required String? searchText,
  });
  FutureResult<List<PharmacyProductAddModel>>
      getPharmacyCategoryProductDetails({
    required String? categoryId,
    required String? pharmacyId,
    required String? searchText,
  });
  void clearPharmacyFetchData();
  void clearPharmacyAllProductFetchData();
  void clearPharmacyCategoryProductFetchData();


  FutureResult<List<PharmacyModel>> fetchPharmacyLocationBasedData(PlaceMark placeMark) {
    throw UnimplementedError('fetchProduct is not implemented');
  }

  FutureResult<Unit> fecthPharmacyLocation(PlaceMark placeMark) {
    throw UnimplementedError('fecthUserLocaltion is not implemented');
  }

  void clearPharmacyLocationData() {
    throw UnimplementedError('clearData is not implemented');
  }
  FutureResult<List<PharmacyModel>> getAllPharmacy({
    required String? searchText,
  });
    FutureResult<PharmacyModel>getSinglePharmacy({
    required String pharmacyId,
  });
  FutureResult<List<PharmacyCategoryModel>> getpharmacyCategory({
    required List<String> categoryIdList,
  });

  FutureResult<List<PharmacyBannerModel>> getPharmacyBanner({
    required String pharmacyId,
  });
  FutureResult<Map<String, dynamic>> createOrGetProductToUserCart({
    required String pharmacyId,
    required String userId,
  });

  FutureResult<Map<String, int>> addProductToUserCart({
    required Map<String, int> cartProduct,
    required String pharmacyId,
    required String userId,
  });
    FutureResult<Unit> removeProductFromUserCart({
    required String cartProductId,
    required String pharmacyId,
    required String userId,
  });

  FutureResult<PharmacyOrderModel> createProductOrderDetails({
    required PharmacyOrderModel orderProducts, required String pharmacyId,
    required String userId,
  });

  FutureResult<List<PharmacyOrderModel>> getProductOrderDetails({
    required String userId,
    required String pharmacyId,
  });

  void clearProductOrderFetchData();

  FutureResult<PharmacyOrderModel> updateProductOrderDetails({
    required String orderProductId,
    required PharmacyOrderModel orderProducts,
  });

  FutureResult<List<PharmacyProductAddModel>> getpharmcyCartProduct({
    required List<String> productCartIdList,
  });
}
