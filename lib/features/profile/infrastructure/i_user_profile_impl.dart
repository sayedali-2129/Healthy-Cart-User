import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/image_picker.dart';
import 'package:healthy_cart_user/features/profile/domain/facade/i_user_profile_facade.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_family_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IUserProfileFacade)
class IUserProfileImpl implements IUserProfileFacade {
  IUserProfileImpl(this._firestore, this._imageService);

  final FirebaseFirestore _firestore;
  final ImageService _imageService;

/* ---------------------------- ADD USER DETAILS ---------------------------- */
  @override
  FutureResult<String> addUserDetails(
      {required UserModel userModel, required String userId}) async {
    final batch = _firestore.batch();
    try {
      final userDoc =
          _firestore.collection(FirebaseCollections.userCollection).doc(userId);
      final counterDoc = _firestore
          .collection(FirebaseCollections.counts)
          .doc('htfK5JIPTaZVlZi6fGdZ');
      batch.update(userDoc, userModel.toMap());
      batch.update(counterDoc, {'userCount': FieldValue.increment(1)});
      await batch.commit();
      return right('User Details Added Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* --------------------------- UPDATE USER DETAILS -------------------------- */
  @override
  FutureResult<String> updateUserDetails(
      {required UserModel userModel, required String userId}) async {
    try {
      await _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .update(userModel.toEditMap());
      return right('User Details Updated Successfully');
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ---------------------------- PICK USER IMAGE ---------------------------- */
  @override
  FutureResult<File> pickUserImage() async {
    return await _imageService.getGalleryImage(
        imagesource: ImageSource.gallery);
  }

/* ----------------------------- SAVE USER IMAGE ---------------------------- */
  @override
  FutureResult<String> uploadUserImage(File imageFile) async {
    return await _imageService.saveImage(
        imageFile: imageFile, folderName: 'Users');
  }

/* --------------------- DELETE USER IMAGE FROM STORAGE --------------------- */
  @override
  FutureResult<Unit> deleteStorageImage(
      {required String imageUrl, required String userId}) async {
    try {
      await _imageService.deleteImageUrl(imageUrl: imageUrl).then((value) {
        value.fold((failure) {
          return left(failure);
        }, (success) async {
          await _firestore
              .collection(FirebaseCollections.userCollection)
              .doc(userId)
              .update({'image': null}).then((value) {});
        });
      });
      return right(unit);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ---------------------------- ADD USER ADDRESS ---------------------------- */
  @override
  FutureResult<UserAddressModel> addUserAddress(
      {required String userId,
      required UserAddressModel addressModel,
      required String addressId}) async {
    try {
      Map<String, dynamic> addressMap = addressModel.toMap();

      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userAddressCollection)
          .doc('user_addresses');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> addressData = {};
      if (snapshot.exists) {
        addressData = snapshot.data() as Map<String, dynamic>;
      }

      String newAddressKey = addressId;
      addressMap['id'] = newAddressKey;
      addressData[newAddressKey] = addressMap;

      await docRef.set(addressData);

      return right(UserAddressModel.fromMap(addressMap)
          .copyWith(id: addressId, userId: userId));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ---------------------------- GET USER ADDRESS ---------------------------- */
  @override
  FutureResult<List<UserAddressModel>> getUserAddress(
      {required String userId}) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userAddressCollection)
          .doc('user_addresses');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> addressData = {};
      if (snapshot.exists) {
        addressData = snapshot.data() as Map<String, dynamic>;

        final addressList = addressData.values
            .map((addressMap) =>
                UserAddressModel.fromMap(addressMap as Map<String, dynamic>))
            .toList();

        return right(addressList);
      } else {
        return right([]);
      }
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* --------------------------- UPDATE USER ADDRESS -------------------------- */

  @override
  FutureResult<UserAddressModel> updateUserAddress(
      {required String userId,
      required UserAddressModel addressModel,
      required String addressId}) async {
    try {
      Map<String, dynamic> addressMap = addressModel.toEditMap();

      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userAddressCollection)
          .doc('user_addresses');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> addressData = {};
      if (snapshot.exists) {
        addressData = snapshot.data() as Map<String, dynamic>;
      }

      addressMap['id'] = addressId;
      addressData[addressId] = addressMap;

      await docRef.set(addressData);

      return right(UserAddressModel.fromMap(addressMap)
          .copyWith(id: addressId, userId: userId));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* ----------------------------- REMOVE ADDRESS ----------------------------- */
  @override
  FutureResult<String> deleteUserAddress(
      {required String userId, required String addressId}) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userAddressCollection)
          .doc('user_addresses');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> addressData = {};
      if (snapshot.exists) {
        addressData = snapshot.data() as Map<String, dynamic>;
      }
      if (addressData.containsKey(addressId)) {
        addressData.remove(addressId);
        await docRef.set(addressData);
        return right('Address Removed Successfully');
      } else {
        return left(
            const MainFailure.generalException(errMsg: 'Address not found'));
      }
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ---------------------------- ADD USER FAMILY MEMBER ---------------------------- */
  @override
  FutureResult<UserFamilyMembersModel> addUserFamilyMember(
      {required String userId,
      required UserFamilyMembersModel familyMemberModel,
      required String familyMemberId}) async {
    try {
      Map<String, dynamic> familyMembeMap = familyMemberModel.toMap();
      log(familyMembeMap.toString());

      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userFamilyMemberCollection)
          .doc('user_family_members');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> familyMembeData = {};
      if (snapshot.exists) {
        familyMembeData = snapshot.data() as Map<String, dynamic>;
      }

      String newAddressKey = familyMemberId;
      familyMembeMap['id'] = newAddressKey;
      familyMembeData[newAddressKey] = familyMembeMap;

      await docRef.set(familyMembeData);

      return right(UserFamilyMembersModel.fromMap(familyMembeMap)
          .copyWith(id: familyMemberId, userId: userId));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ---------------------------- GET USER FAMILY MEMBERS ---------------------------- */
  @override
  FutureResult<List<UserFamilyMembersModel>> getUserFamilyMember(
      {required String userId}) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userFamilyMemberCollection)
          .doc('user_family_members');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> familyMemberData = {};
      if (snapshot.exists) {
        familyMemberData = snapshot.data() as Map<String, dynamic>;

        final familyMemberList = familyMemberData.values
            .map((e) =>
                UserFamilyMembersModel.fromMap(e as Map<String, dynamic>))
            .toList();

        return right(familyMemberList);
      } else {
        return right([]);
      }
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* --------------------------- UPDATE USER FAMILY MEMBER -------------------------- */

  @override
  FutureResult<UserFamilyMembersModel> updateUserFamilyMember(
      {required String userId,
      required UserFamilyMembersModel familyMemberModel,
      required String familyMemberId}) async {
    try {
      Map<String, dynamic> familyMemberMap = familyMemberModel.toEditMap();

      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userFamilyMemberCollection)
          .doc('user_family_members');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> familyMemberData = {};
      if (snapshot.exists) {
        familyMemberData = snapshot.data() as Map<String, dynamic>;
      }

      familyMemberMap['id'] = familyMemberId;
      familyMemberData[familyMemberId] = familyMemberMap;

      await docRef.set(familyMemberData);

      return right(UserFamilyMembersModel.fromMap(familyMemberMap)
          .copyWith(id: familyMemberId, userId: userId));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* -----------------------------USER REMOVE FAMILY MEMBER ----------------------------- */
  @override
  FutureResult<String> deleteFamilyMember({
    required String userId,
    required String familyMemberId,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.userCollection)
          .doc(userId)
          .collection(FirebaseCollections.userFamilyMemberCollection)
          .doc('user_family_members');

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic> familyMemberData = {};
      if (snapshot.exists) {
        familyMemberData = snapshot.data() as Map<String, dynamic>;
      }
      if (familyMemberData.containsKey(familyMemberId)) {
        familyMemberData.remove(familyMemberId);
        await docRef.set(familyMemberData);
        return right('Removed Successfully');
      } else {
        return left(const MainFailure.generalException(errMsg: 'Not found'));
      }
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
