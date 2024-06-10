import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_banner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_user_model.dart';

abstract class IPharmacyFacade{
    FutureResult<List<PharmacyProductAddModel>> getPharmacyAllProductDetails({
    required String? pharmacyId,
    required String? searchText,
  });
  FutureResult<List<PharmacyProductAddModel>> getPharmacyCategoryProductDetails({
    required String? categoryId,
    required String? pharmacyId,
    required String? searchText,
  });
    void clearPharmacyFetchData();
    void clearPharmacyAllProductFetchData();
     void clearPharmacyCategoryProductFetchData();

    FutureResult<List<PharmacyModel>> getAllPharmacy({
    required String? searchText,
  });
    FutureResult<List<PharmacyCategoryModel>> getpharmacyCategory({
    required List<String> categoryIdList,
  });

  FutureResult<List<PharmacyBannerModel>> getPharmacyBanner({
    required String pharmacyId,
  });
}