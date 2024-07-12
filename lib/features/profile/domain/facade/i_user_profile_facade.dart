import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_family_model.dart';
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

  FutureResult<UserAddressModel> addUserAddress(
      {required String userId,
      required UserAddressModel addressModel,
      required String addressId});
  FutureResult<List<UserAddressModel>> getUserAddress({required String userId});

  FutureResult<UserAddressModel> updateUserAddress(
      {required String userId,
      required UserAddressModel addressModel,
      required String addressId});
  FutureResult<String> deleteUserAddress(
      {required String userId, required String addressId});

  FutureResult<UserFamilyMembersModel> addUserFamilyMember({
    required String userId,
    required UserFamilyMembersModel familyMemberModel,
    required String familyMemberId,
  });
  FutureResult<List<UserFamilyMembersModel>> getUserFamilyMember(
      {required String userId});

  FutureResult<UserFamilyMembersModel> updateUserFamilyMember({
    required String userId,
    required UserFamilyMembersModel familyMemberModel,
    required String familyMemberId,
  });
  FutureResult<String> deleteFamilyMember({
    required String userId,
    required String familyMemberId,
  });
}
