import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/core/services/image_picker.dart';
import 'package:healthy_cart_user/features/profile/domain/facade/i_user_profile_facade.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
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
    return await _imageService.getGalleryImage();
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
}
