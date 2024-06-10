// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/textfield_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_dropdown.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({
    super.key,
    this.userAddressModel,
    this.index,
  });
  final UserAddressModel? userAddressModel;
  final int? index;

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final provider = context.read<UserAddressProvider>();
        if (widget.userAddressModel != null) {
          provider.setEditData(widget.userAddressModel!);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserAddressProvider, AuthenticationProvider>(
        builder: (context, addressProvider, authProvider, _) {
      return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            addressProvider.clearFields();
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
                    key: addressProvider.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.userAddressModel != null
                              ? 'Edit Address'
                              : 'Add New Address',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        const Gap(10),
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Full Name*',
                          hintText: 'Enter your full name',
                          controller: addressProvider.fullNameController,
                          validator: BValidator.validate,
                        ),
                        const Gap(8),
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Address*',
                          hintText: 'House No/ Flat No/ Block No.',
                          controller: addressProvider.addressController,
                          validator: BValidator.validate,
                        ),
                        const Gap(8),
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Landmark*',
                          hintText: 'Enter your landmark',
                          maxLendth: 200,
                          controller: addressProvider.landmarkController,
                          validator: BValidator.validate,
                        ),
                        const Gap(8),
                        TextfieldWidget(
                          enableHeading: true,
                          fieldHeading: 'Phone Number*',
                          hintText: 'Phone Number',
                          maxLendth: 10,
                          keyboardType: TextInputType.number,
                          controller: addressProvider.phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter phone number';
                            } else if (value.length < 10) {
                              return 'Please enter valid phone number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address Type*',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: BColors.grey),
                                ),
                                Gap(8),
                                AddressDropDown(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pincode*',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: BColors.grey),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: TextfieldWidget(
                                    maxLendth: 6,
                                    keyboardType: TextInputType.number,
                                    enableHeading: false,
                                    hintText: 'Enter pincode',
                                    controller:
                                        addressProvider.pincodeController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter pincode';
                                      } else if (value.length < 6) {
                                        return 'Please enter valid pincode';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Gap(30),
                        ButtonWidget(
                          buttonHeight: 40,
                          buttonWidth: double.infinity,
                          buttonColor: BColors.mainlightColor,
                          buttonWidget: Text(
                            widget.userAddressModel != null
                                ? 'Update Address'
                                : 'Save Address',
                            style: const TextStyle(color: BColors.white),
                          ),
                          onPressed: () async {
                            if (!addressProvider.formKey.currentState!
                                .validate()) {
                              addressProvider.formKey.currentState!.validate();
                              return;
                            } else {
                              if (widget.userAddressModel == null) {
                                LoadingLottie.showLoading(
                                    context: context,
                                    text: 'Saving Address...');
                                await addressProvider.addUserAddress(
                                    userId: authProvider
                                        .userFetchlDataFetched!.id!);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                log(widget.userAddressModel!
                                    .toMap()
                                    .toString());
                                LoadingLottie.showLoading(
                                    context: context, text: 'Updating...');

                                await addressProvider.updateUserAddress(
                                    userId:
                                        authProvider.userFetchlDataFetched!.id!,
                                    addressId: widget.userAddressModel!.id!,
                                    index: widget.index!);
                                Navigator.pop(context);
                                Navigator.pop(context);
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
