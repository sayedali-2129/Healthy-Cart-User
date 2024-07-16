// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/textfield_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_family_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_family_model.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/member_drop_down.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class FamilyMemberBottomSheet extends StatefulWidget {
  const FamilyMemberBottomSheet({
    super.key,
    this.userFamilyMembersModel,
    this.index,
  });
  final UserFamilyMembersModel? userFamilyMembersModel;
  final int? index;

  @override
  State<FamilyMemberBottomSheet> createState() =>
      _FamilyMemberBottomSheetState();
}

class _FamilyMemberBottomSheetState extends State<FamilyMemberBottomSheet> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final provider = context.read<UserFamilyMembersProvider>();
        if (widget.userFamilyMembersModel != null) {
          provider.setEditData(widget.userFamilyMembersModel!);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserFamilyMembersProvider, AuthenticationProvider>(
        builder: (context, familyMemberProvider, authProvider, _) {
      return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            familyMemberProvider.clearFields();
          }
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: familyMemberProvider.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Name*',
                          hintText: 'Enter Name',
                          validator: BValidator.validate,
                          controller: familyMemberProvider.nameController,
                        ),
                        const Gap(16),
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Age*',
                          hintText: 'Enter Age',
                          validator: BValidator.validate,
                          keyboardType: TextInputType.number,
                          controller: familyMemberProvider.ageController,
                        ),
                        const Gap(16),
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Place*',
                          hintText: 'Enter Place',
                          validator: BValidator.validate,
                          controller: familyMemberProvider.placeController,
                        ),
                        const Gap(16),
                        TextfieldWidget(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          enableHeading: true,
                          maxLendth: 10,
                          fieldHeading: 'Phone Number*',
                          hintText: 'Enter Phone Number',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Phone Number';
                            } else if (value.length < 6 || value.length > 12) {
                              return 'Enter valid phone number';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          controller:
                              familyMemberProvider.phoneNumberController,
                        ),
                        const Gap(16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Gender*',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: BColors.black),
                            ),
                          ],
                        ),
                        const FamilyMembersGenderDropdown(),
                        const Gap(30),
                        ButtonWidget(
                          buttonHeight: 40,
                          buttonWidth: double.infinity,
                          buttonColor: BColors.mainlightColor,
                          buttonWidget: Text(
                            widget.userFamilyMembersModel != null
                                ? 'Update Member'
                                : 'Save Member',
                            style: const TextStyle(color: BColors.white),
                          ),
                          onPressed: () async {
                            if (!familyMemberProvider.formKey.currentState!
                                .validate()) {
                              familyMemberProvider.formKey.currentState!
                                  .validate();
                              return;
                            } else {
                              if (familyMemberProvider.selectedGenderDrop ==
                                  null) {
                                CustomToast.infoToast(
                                    text: 'Select gender option');
                                return;
                              }
                              if (widget.userFamilyMembersModel == null) {
                                LoadingLottie.showLoading(
                                    context: context, text: 'Saving Member...');
                                await familyMemberProvider.addUserFamilyMember(
                                    userId: authProvider
                                            .userFetchlDataFetched!.id ??
                                        '');
                               EasyNavigation.pop(context: context);
                               EasyNavigation.pop(context: context);
                              } else {
                                LoadingLottie.showLoading(
                                    context: context, text: 'Updating...');

                                await familyMemberProvider
                                    .updateUserFamilyMember(
                                        userId: authProvider
                                            .userFetchlDataFetched!.id!,
                                        familyMemberId:
                                            widget.userFamilyMembersModel?.id ??
                                                '',
                                        index: widget.index!);
                                EasyNavigation.pop(context: context);
                               EasyNavigation.pop(context: context);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
