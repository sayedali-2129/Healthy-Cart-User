import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/image_picker.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/i_pharmacy_facade.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_banner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_category_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPharmacyFacade)
class IPharmacyImpl implements IPharmacyFacade {
  IPharmacyImpl(this._firebaseFirestore, this._imageService);
  final FirebaseFirestore _firebaseFirestore;
  final ImageService _imageService;

//// Image section --------------------------
  @override
  FutureResult<File> getImage({required ImageSource imagesource}) async {
    return await _imageService.getGalleryImage(imagesource: imagesource);
  }

  @override
  FutureResult<String> saveImage({required File imageFile}) async {
    return await _imageService.saveImage(
        imageFile: imageFile, folderName: 'doctor_image');
  }

  DocumentSnapshot<Map<String, dynamic>>? lastPharmacyDoc;
  bool noMorePharmacyData = false;

  @override
  void clearPharmacyFetchData() {
    noMorePharmacyData = false;
    lastPharmacyDoc = null;
  }

  @override
  FutureResult<List<PharmacyModel>> getAllPharmacy(
      {required String? searchText}) async {
    try {
      if (noMorePharmacyData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacy)
          .orderBy('createdAt', descending: true);

      if (searchText != null && searchText.isNotEmpty) {
        query = query.where('pharmacyKeywords',
            arrayContains: searchText.toLowerCase());
      }
      if (lastPharmacyDoc != null) {
        query = query.startAfterDocument(lastPharmacyDoc!);
        log(lastPharmacyDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMorePharmacyData = true;
      } else {
        lastPharmacyDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyModel> pharmacyList = snapshots.docs
          .map((e) => PharmacyModel.fromMap(e.data() as Map<String, dynamic>)
              .copyWith(id: e.id))
          .toList();
      return right(pharmacyList);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastAllProductDoc;
  bool noMoreAllProductData = false;
  @override
  void clearPharmacyAllProductFetchData() {
    lastAllProductDoc = null;
    noMoreAllProductData = false;
  }

  @override
  FutureResult<List<PharmacyProductAddModel>> getPharmacyAllProductDetails({
    required String? pharmacyId,
    required String? searchText,
  }) async {
    try {
      if (noMoreAllProductData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId);

      if (searchText != null && searchText.isNotEmpty) {
        query =
            query.where('keywords', arrayContains: searchText.toLowerCase());
      }
      if (lastAllProductDoc != null) {
        query = query.startAfterDocument(lastAllProductDoc!);
        log(lastAllProductDoc!.id.toString());
      }
      final snapshots = await query.limit(4).get();
      if (snapshots.docs.length < 4 || snapshots.docs.isEmpty) {
        noMoreAllProductData = true;
      } else {
        lastAllProductDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyProductAddModel> productList = snapshots.docs
          .map((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastCategoryProductDoc;
  bool noMoreCategoryProductData = false;

  @override
  void clearPharmacyCategoryProductFetchData() {
    noMoreCategoryProductData = false;
    lastCategoryProductDoc = null;
  }

  @override
  FutureResult<List<PharmacyProductAddModel>>
      getPharmacyCategoryProductDetails({
    required String? categoryId,
    required String? pharmacyId,
    required String? searchText,
  }) async {
    try {
      if (noMoreCategoryProductData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('categoryId', isEqualTo: categoryId);
      log('Category Id from Implementation  $categoryId');
      if (searchText != null && searchText.isNotEmpty) {
        query =
            query.where('keywords', arrayContains: searchText.toLowerCase());
      }
      if (lastCategoryProductDoc != null) {
        query = query.startAfterDocument(lastCategoryProductDoc!);
        log(lastCategoryProductDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMoreCategoryProductData = true;
      } else {
        lastCategoryProductDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyProductAddModel> productList = snapshots.docs
          .map((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyCategoryModel>> getpharmacyCategory(
      {required List<String> categoryIdList}) async {
    try {
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];

      for (var element in categoryIdList) {
        futures.add(_firebaseFirestore
            .collection(FirebaseCollections.pharmacycategory)
            .doc(element)
            .get());
      }

      List<DocumentSnapshot<Map<String, dynamic>>> results =
          await Future.wait<DocumentSnapshot<Map<String, dynamic>>>(futures);

      final categoryList = results
          .map<PharmacyCategoryModel>((e) =>
              PharmacyCategoryModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();

      return right(categoryList);
    } on FirebaseException catch (e) {
      log(e.toString());
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      log(e.toString());

      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyBannerModel>> getPharmacyBanner(
      {required String pharmacyId}) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyBanner)
          .orderBy('isCreated', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .get();
      return right([
        ...snapshot.docs.map(
            (e) => PharmacyBannerModel.fromMap(e.data()).copyWith(id: e.id))
      ]);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.toString()));
    }
  }

  /* ------------------------- PRODUCT IN CART ------------------------- */
  @override
  FutureResult<Map<String, dynamic>> createOrGetProductToUserCart({
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final docRef = _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.pharmacyCart)
          .doc(pharmacyId);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        final productDetails = snapshot.data();
        Map<String, dynamic> productData = productDetails?['productDetails'];
        return right(productData);
      } else {
        await docRef.set({'productDetails': {}});
        return right({});
      }
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<Map<String, int>> addProductToUserCart({
    required Map<String, int> cartProduct,
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final docRef = _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.pharmacyCart)
          .doc(pharmacyId);
      // Update the Firestore document with the modified list
      await docRef
          .set({'productDetails': cartProduct}, SetOptions(merge: true));
      return right(cartProduct);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyProductAddModel>> getpharmcyCartProduct(
      {required List<String> productCartIdList}) async {
    try {
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];
      for (var element in productCartIdList) {
        futures.add(_firebaseFirestore
            .collection(FirebaseCollections.pharmacyProduct)
            .doc(element)
            .get());
      }

      List<DocumentSnapshot<Map<String, dynamic>>> results =
          await Future.wait<DocumentSnapshot<Map<String, dynamic>>>(futures);

      final cartProductList = results
          .map<PharmacyProductAddModel>((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(cartProductList);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<Unit> removeProductFromUserCart({
    required String cartProductId,
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final docRef = _firebaseFirestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.pharmacyCart)
          .doc(pharmacyId);
      // Update the Firestore document with the modified list
      await docRef.update(
        {'productDetails.$cartProductId': FieldValue.delete()},
      );
      return right(unit);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }


  /* ------------------------- order and cart section ------------------------- */
  @override
  FutureResult<PharmacyOrderModel> createProductOrderDetails({
    required PharmacyOrderModel orderProducts,
    required String pharmacyId,
    required String userId,
  }) async {
    try {
      final batch = _firebaseFirestore.batch();
      final id = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc()
          .id;
      orderProducts.id = id;
      batch.set(
          _firebaseFirestore
              .collection(FirebaseCollections.pharmacyOrder)
              .doc(id),
          orderProducts.toMap());
      batch.set(
          _firebaseFirestore
              .collection(FirebaseCollections.userCollection)
              .doc(userId)
              .collection(FirebaseCollections.pharmacyCart)
              .doc(pharmacyId),
          {'productDetails': {}});
      await batch.commit();
      return right(orderProducts.copyWith(id: id));
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastProductOrderDoc;
  bool noMoreProductOrderData = false;
  @override
  FutureResult<List<PharmacyOrderModel>> getProductOrderDetails(
      {required String userId, required String pharmacyId}) async {
    try {
      if (noMoreProductOrderData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('createdAt', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('userId', isEqualTo: userId);
      if (lastProductOrderDoc != null) {
        query = query.startAfterDocument(lastProductOrderDoc!);
        log(lastProductOrderDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMoreProductOrderData = true;
      } else {
        lastProductOrderDoc =
            snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyOrderModel> productOrderList = snapshots.docs
          .map((e) =>
              PharmacyOrderModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productOrderList);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearProductOrderFetchData() {
    lastProductOrderDoc = null;
    noMoreProductOrderData = false;
  }

  @override
  FutureResult<PharmacyOrderModel> updateProductOrderDetails(
      {required String orderProductId,
      required PharmacyOrderModel orderProducts}) async {
    log(orderProductId);
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderProductId)
          .update(orderProducts.toMap());

      return right(orderProducts.copyWith(id: orderProductId));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
  /* -------------------------------------------------------------------------- */
}
