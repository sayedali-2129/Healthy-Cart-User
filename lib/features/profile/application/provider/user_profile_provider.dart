import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/keyword_builder.dart';
import 'package:healthy_cart_user/features/profile/domain/facade/i_user_profile_facade.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserProfileProvider with ChangeNotifier {
  UserProfileProvider(this.iUserProfileFacade);
  final IUserProfileFacade iUserProfileFacade;

  String? userId = FirebaseAuth.instance.currentUser?.uid;
  String? imageUrl;
  File? imageFile;
  UserModel? userModel;

  /* -------------------------- USER TEXT CONTROLLERS ------------------------- */
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String? genderDropdownValue;

  List<String> userKeywords() {
    return keywordsBuilder(nameController.text);
  }

  Future<void> pickUserImage() async {
    final result = await iUserProfileFacade.pickUserImage();
    result.fold((error) {
      CustomToast.errorToast(text: error.errMsg);
      log('ERROR IN PICK IMAGE:$error');
    }, (imageSuccess) async {
      if (imageUrl != null) {
        await iUserProfileFacade.deleteStorageImage(
            imageUrl: imageUrl!, userId: userId ?? '');
        imageUrl = null;
      }
      imageFile = imageSuccess;
      notifyListeners();
    });
  }

  Future<void> uploadUserImage() async {
    if (imageFile == null && imageUrl == null) {
      CustomToast.errorToast(text: 'Please check the image selected');
      return;
    }
    final result = await iUserProfileFacade.uploadUserImage(imageFile!);
    result.fold((error) {
      CustomToast.errorToast(text: error.errMsg);
      log('ERROR IN UPLOAD IMAGE:$error');
    }, (url) {
      imageUrl = url;
      notifyListeners();
    });
  }

  Future<void> addUserDetails({required BuildContext context}) async {
    userModel = UserModel(
      userName: nameController.text,
      userEmail: emailController.text,
      userAge: ageController.text,
      gender: genderDropdownValue,
      id: userId,
      image: imageUrl,
      phoneNo: phoneNumberController.text,
      keywords: userKeywords(),
    );

    final result = await iUserProfileFacade.addUserDetails(
        userModel: userModel ?? UserModel(), userId: userId!);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
        Navigator.pop(context);
      },
      (success) {
        clearData();
        CustomToast.sucessToast(text: success);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    notifyListeners();
  }

  Future<void> updateUserDetails({required BuildContext context}) async {
    userModel = UserModel(
      userName: nameController.text,
      userEmail: emailController.text,
      userAge: ageController.text,
      phoneNo: phoneNumberController.text,
      image: imageUrl,
      gender: genderDropdownValue,
      keywords: userKeywords(),
    );
    final result = await iUserProfileFacade.updateUserDetails(
        userModel: userModel ?? UserModel(), userId: userId!);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
      },
      (success) {
        clearData();
        CustomToast.sucessToast(text: success);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    notifyListeners();
  }

  void setEditData(UserModel editModel) {
    nameController.text = editModel.userName ?? '';
    emailController.text = editModel.userEmail ?? '';
    ageController.text = editModel.userAge ?? '';
    phoneNumberController.text = editModel.phoneNo!;
    imageUrl = editModel.image;
    genderDropdownValue = editModel.gender;
    notifyListeners();
  }

  void removeProfileImage() {
    imageUrl = null;
    imageFile = null;
    notifyListeners();
  }

  void clearData() {
    nameController.clear();
    emailController.clear();
    ageController.clear();

    phoneNumberController.clear();
    genderDropdownValue = null;
    imageUrl = null;
    imageFile = null;
    notifyListeners();
  }
}
