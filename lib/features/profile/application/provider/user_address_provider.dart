import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/profile/domain/facade/i_user_profile_facade.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class UserAddressProvider with ChangeNotifier {
  UserAddressProvider(this.iUserProfileFacade);

  final IUserProfileFacade iUserProfileFacade;

  var uuid = const Uuid();

  final formKey = GlobalKey<FormState>();

  UserAddressModel? userAddressModel;
  List<UserAddressModel> userAddressList = [];
  UserAddressModel? selectedAddress;

  bool isLoading = false;
  bool addLoading = false;

  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  String? selectedAddressType;

  Future<void> addUserAddress({required String userId}) async {
    addLoading = true;
    notifyListeners();

    UserAddressModel userAddressModel = UserAddressModel(
        address: addressController.text,
        landmark: landmarkController.text,
        name: fullNameController.text,
        phoneNumber: phoneController.text,
        pincode: pincodeController.text,
        addressType: selectedAddressType,
        createdAt: Timestamp.now(),
        userId: userId);

    final result = await iUserProfileFacade.addUserAddress(
        addressId: uuid.v4(), userId: userId, addressModel: userAddressModel);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
        log('Error: ${err.errMsg}');
      },
      (success) {
        CustomToast.sucessToast(text: 'User address added successfully');
        userAddressList.insert(0, success);
        selectedAddress = success;
        clearFields();
      },
    );
    addLoading = false;
    notifyListeners();
  }

/* ---------------------------- GET USER ADDRESS ---------------------------- */
  Future<void> getUserAddress({required String userId}) async {
    userAddressList = [];
    isLoading = true;
    notifyListeners();
    final result = await iUserProfileFacade.getUserAddress(userId: userId);
    result.fold(
      (err) {
        log('Error: ${err.errMsg}');
        isLoading = false;
        notifyListeners();
      },
      (addressList) {
        log('user address fetched');
        userAddressList = addressList;
        log('userAddressList: ${userAddressList.length}');
        if (userAddressList.isNotEmpty) {
          selectedAddress = userAddressList.first;
        }
        isLoading = false;
        notifyListeners();
      },
    );
  }

  /* ----------------------------- UPDATE ADDRESS ----------------------------- */
  Future<void> updateUserAddress(
      {required String userId,
      required String addressId,
      required int index}) async {
    addLoading = true;
    notifyListeners();
    UserAddressModel userAddressModel = UserAddressModel(
      address: addressController.text,
      landmark: landmarkController.text,
      name: fullNameController.text,
      phoneNumber: phoneController.text,
      pincode: pincodeController.text,
      addressType: selectedAddressType,
      createdAt: Timestamp.now(),
    );

    final result = await iUserProfileFacade.updateUserAddress(
        userId: userId, addressModel: userAddressModel, addressId: addressId);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
        log('Error: ${err.errMsg}');
      },
      (success) {
        CustomToast.sucessToast(text: 'User updated successfully');
        userAddressList.removeAt(index);
        userAddressList.insert(index, success);
        log(success.toMap().toString());
        clearFields();
      },
    );
    addLoading = false;
    notifyListeners();
  }

  /* ----------------------------- REMOVE ADDRESS ----------------------------- */
  Future<void> removeAddress(
      {required String userId,
      required String addressId,
      required int index}) async {
    final result = await iUserProfileFacade.deleteUserAddress(
        userId: userId, addressId: addressId);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
      },
      (success) {
        CustomToast.sucessToast(text: success);
        userAddressList.removeAt(index);
      },
    );
    notifyListeners();
  }

  /* ---------------------------- ADDRESS EDIT DATA --------------------------- */
  void setEditData(UserAddressModel addressModel) {
    addressController.text = addressModel.address!;
    landmarkController.text = addressModel.landmark!;
    fullNameController.text = addressModel.name!;
    phoneController.text = addressModel.phoneNumber!;
    pincodeController.text = addressModel.pincode!;
    selectedAddressType = addressModel.addressType;
    notifyListeners();
  }

/* ------------------------------ CLEAR FIELDS ------------------------------ */
  void clearFields() {
    addressController.clear();
    landmarkController.clear();
    fullNameController.clear();
    phoneController.clear();
    pincodeController.clear();
    selectedAddressType = null;
    notifyListeners();
  }

  void setSelectedAddress(UserAddressModel address) {
    selectedAddress = address;

    notifyListeners();
  }
}
