

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/profile/domain/facade/i_user_profile_facade.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_family_model.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class UserFamilyMembersProvider with ChangeNotifier {
  UserFamilyMembersProvider(this.iUserProfileFacade);

  final IUserProfileFacade iUserProfileFacade;

  var uuid = const Uuid();

  final formKey = GlobalKey<FormState>();

  UserFamilyMembersModel? userFamilyMembersModel;
  List<UserFamilyMembersModel> userFamilyMemberList = [];
  UserFamilyMembersModel? selectedFamilyMember;

  bool isLoading = false;
  bool addLoading = false;

  final TextEditingController placeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGenderDrop;

  Future<void> addUserFamilyMember({required String userId}) async {
    addLoading = true;
    notifyListeners();

    UserFamilyMembersModel userFamilyMembersModel = UserFamilyMembersModel(
       name: nameController.text,
       phoneNo: phoneNumberController.text.trim(),
       place:placeController.text , 
       age: ageController.text.trim(),
       gender: selectedGenderDrop,
        createdAt: Timestamp.now(),
        userId: userId);

    final result = await iUserProfileFacade.addUserFamilyMember(
        familyMemberId: uuid.v4(), userId: userId, familyMemberModel: userFamilyMembersModel);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
        //log('Error: ${err.errMsg}');
      },
      (success) {
        CustomToast.sucessToast(text: 'Member added successfully');
        userFamilyMemberList.insert(0, success);
        selectedFamilyMember = success;
        clearFields();
      },
    );
    addLoading = false;
    notifyListeners();
  }

/* ---------------------------- GET USER ADDRESS ---------------------------- */
  Future<void> getUserFamilyMember({required String userId}) async {
    userFamilyMemberList = [];
    isLoading = true;
    notifyListeners();
    final result = await iUserProfileFacade.getUserFamilyMember(userId: userId);
    result.fold(
      (err) {
       // log('Error: ${err.errMsg}');
        isLoading = false;
        notifyListeners();
      },
      (memberList) {
       // log('user member fetched');
        userFamilyMemberList = memberList;
        //log('userFamilyMemberList: ${userFamilyMemberList.length}');
        if (userFamilyMemberList.isNotEmpty) {
          selectedFamilyMember = userFamilyMemberList.first;
        }
        isLoading = false;
        notifyListeners();
      },
    );
  }

  /* ----------------------------- UPDATE ADDRESS ----------------------------- */
  Future<void> updateUserFamilyMember(
      {required String userId,
      required String familyMemberId,
      required int index}) async {
    addLoading = true;
    notifyListeners();
    UserFamilyMembersModel userFamilyMembersModel = UserFamilyMembersModel(
       name: nameController.text,
       phoneNo: phoneNumberController.text.trim(),
       place:placeController.text , 
       age: ageController.text.trim(),
       gender: selectedGenderDrop,
      createdAt: Timestamp.now(),
    );

    final result = await iUserProfileFacade.updateUserFamilyMember(
        userId: userId, familyMemberModel: userFamilyMembersModel, familyMemberId: familyMemberId);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
       // log('Error: ${err.errMsg}');
      },
      (success) {
        CustomToast.sucessToast(text: 'User updated successfully');
        userFamilyMemberList.removeAt(index);
        userFamilyMemberList.insert(index, success);
       // log(success.toMap().toString());
        clearFields();
      },
    );
    addLoading = false;
    notifyListeners();
  }

  /* ----------------------------- REMOVE ADDRESS ----------------------------- */
  Future<void> deleteFamilyMember(
      {required String userId,
      required String familyMemberId,
      required int index}) async {
    final result = await iUserProfileFacade.deleteFamilyMember(
        userId: userId, familyMemberId: familyMemberId);
    result.fold(
      (err) {
        CustomToast.errorToast(text: err.errMsg);
      },
      (success) {
        CustomToast.sucessToast(text: success);
        userFamilyMemberList.removeAt(index);
      },
    );
    notifyListeners();
  }

  /* ---------------------------- ADDRESS EDIT DATA --------------------------- */
  void setEditData(UserFamilyMembersModel familyMemberModel) {
    nameController.text = familyMemberModel.name!;
    placeController.text = familyMemberModel.place!;
    ageController.text = familyMemberModel.age!;
    phoneNumberController.text = familyMemberModel.phoneNo!;
    selectedGenderDrop = familyMemberModel.gender;
    notifyListeners();
  }

/* ------------------------------ CLEAR FIELDS ------------------------------ */
  void clearFields() {
    nameController.clear();
    placeController.clear();
    ageController.clear();
    phoneNumberController.clear();
    selectedGenderDrop = null;
    notifyListeners();
  }

  void setSelectedFamilyMember(UserFamilyMembersModel member) {
    selectedFamilyMember = member;
    notifyListeners();
  }
}
