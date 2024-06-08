import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';

abstract class IUserProfileFacade {
  FutureResult<File> pickUserImage();
  FutureResult<String> uploadUserImage(File imageFile);
  FutureResult<Unit> deleteStorageImage(
      {required String imageUrl, required String userId});
  FutureResult<String> addUserDetails(
      {required UserModel userModel, required String userId});
  FutureResult<String> updateUserDetails(
      {required UserModel userModel, required String userId});
}
