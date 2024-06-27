// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/textfield_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_profile_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/gender_dropdown.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/user_image_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key, this.userModel});
  final UserModel? userModel;

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;

  @override
  void initState() {
    final provider = context.read<UserProfileProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setEditData(widget.userModel!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, UserProfileProvider>(
        builder: (context, authProvider, profileProvider, _) {
      profileProvider.phoneNumberController.text = phoneNumber!;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: BColors.mainlightColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8))),
          title: const Text(
            'Fill Profile Details',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          shadowColor: BColors.black.withOpacity(0.8),
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /* ---------------------------------- IMAGE --------------------------------- */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserImageContainer(
                        userModel: widget.userModel,
                      ),
                    ],
                  ),
                  const Gap(16),
                  /* ---------------------------------- NAME ---------------------------------- */
                  TextfieldWidget(
                    fieldHeading: 'Name*',
                    hintText: 'Please Enter Your Name',
                    controller: profileProvider.nameController,
                    validator: BValidator.validate,
                  ),
                  const Gap(16),
                  /* ------------------------------ PHONE NUMBER ------------------------------ */
                  TextfieldWidget(
                    fieldHeading: 'Phone Number*',
                    controller: profileProvider.phoneNumberController,
                    readOnly: true,
                  ),
                  const Gap(16),
                  /* ---------------------------------- EMAIL --------------------------------- */
                  TextfieldWidget(
                    fieldHeading: 'Email*',
                    hintText: 'Please Enter Your Email',
                    controller: profileProvider.emailController,
                    validator: (value) => EmailValidator.validate(
                            profileProvider.emailController.text)
                        ? null
                        : "Please enter valid email",
                  ),
                  const Gap(16),
                  /* ----------------------------------- AGE ---------------------------------- */
                  TextfieldWidget(
                    fieldHeading: 'Age*',
                    hintText: 'Please Enter Your Age',
                    controller: profileProvider.ageController,
                    keyboardType: TextInputType.number,
                    validator: BValidator.validate,
                  ),
                  const Gap(16),
                  /* ----------------------------- GENDER DROPDOWN ---------------------------- */

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
                  GenderDropDown(),
                  const Gap(16),
                  /* -------------------------------- LOCATION -------------------------------- */
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Location*',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: BColors.grey),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<LocationProvider>()
                              .getLocationPermisson();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserLocationSearchWidget()));
                        },
                        child: Container(
                          color: Colors.white,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${authProvider.userFetchlDataFetched?.placemark?.localArea ?? 'Select Location'}, ${authProvider.userFetchlDataFetched?.placemark?.district ?? ''}, ${authProvider.userFetchlDataFetched?.placemark?.state ?? ''}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: BColors.black)),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 22,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  ButtonWidget(
                    buttonHeight: 45,
                    buttonWidth: double.infinity,
                    buttonColor: BColors.mainlightColor,
                    buttonWidget: const Text(
                      'Save',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: BColors.white),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        _formKey.currentState!.validate();
                        return;
                      } else {
                        if (widget.userModel == null) {
                          LoadingLottie.showLoading(
                              context: context, text: 'Saving...');
                          await profileProvider.uploadUserImage().then(
                            (value) async {
                              await profileProvider.addUserDetails(
                                  context: context);
                            },
                          );
                        } else {
                          LoadingLottie.showLoading(
                              context: context, text: 'Updating...');
                          if (profileProvider.imageUrl == null) {
                            await profileProvider.uploadUserImage();
                          }
                          await profileProvider.updateUserDetails(
                              context: context);
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
