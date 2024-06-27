// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/textfield_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/patient_gender_dropdown.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen(
      {super.key,
      required this.doctorIndex,
      required this.selectedDoctor,
      required this.hospitalIndex});
  final int doctorIndex;
  final DoctorModel selectedDoctor;

  final int hospitalIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer2<HospitalProvider, AuthenticationProvider>(
        builder: (context, hospitalProvider, authProvider, _) {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: BColors.mainlightColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8))),
          title: const Text(
            'Patient Details',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: hospitalProvider.formKey,
              child: Column(
                children: [
                  TextfieldWidget(
                    enableHeading: true,
                    fieldHeading: 'Name*',
                    hintText: 'Enter Patient Name',
                    validator: BValidator.validate,
                    controller: hospitalProvider.nameController,
                  ),
                  const Gap(16),
                  TextfieldWidget(
                    enableHeading: true,
                    fieldHeading: 'Age*',
                    hintText: 'Enter Patient Age',
                    validator: BValidator.validate,
                    keyboardType: TextInputType.number,
                    controller: hospitalProvider.ageController,
                  ),
                  const Gap(16),
                  TextfieldWidget(
                    enableHeading: true,
                    fieldHeading: 'Place*',
                    hintText: 'Enter Patient Place',
                    validator: BValidator.validate,
                    controller: hospitalProvider.placeController,
                  ),
                  const Gap(16),
                  TextfieldWidget(
                    enableHeading: true,
                    fieldHeading: 'Phone Number*',
                    hintText: 'Enter Patient Phone Number',
                    validator: BValidator.validate,
                    keyboardType: TextInputType.number,
                    controller: hospitalProvider.numberController,
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
                  const PatientGenderDropdown(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (!hospitalProvider.formKey.currentState!.validate()) {
              hospitalProvider.formKey.currentState!.validate();
            } else {
              ConfirmAlertBoxWidget.showAlertConfirmBox(
                context: context,
                titleText: 'Confirm Booking',
                subText:
                    'This will send your booking to the hospital and check the availability of the slot. Are you sure you want to proceed?',
                confirmButtonTap: () async {
                  LoadingLottie.showLoading(
                      context: context, text: 'Please wait...');
                  await hospitalProvider.addHospitalBooking(
                      hospitalId:
                          hospitalProvider.hospitalList[hospitalIndex].id!,
                      userId: authProvider.userFetchlDataFetched!.id!,
                      userModel: authProvider.userFetchlDataFetched!,
                      hospitalModel:
                          hospitalProvider.hospitalList[hospitalIndex],
                      totalAmount:
                          hospitalProvider.doctorsList[doctorIndex].doctorFee!,
                      selectedDoctor: selectedDoctor);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderRequestSuccessScreen(
                        title:
                            'Your Hospital appointment is currently being processed. We will notify you once its confirmed',
                      ),
                    ),
                    (route) => false,
                  );
                  hospitalProvider.clearControllerData();
                },
              );
            }
          },
          child: Container(
              height: 60,
              color: BColors.mainlightColor,
              child: const Center(
                child: Text(
                  'Check Availability',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: BColors.white),
                ),
              )),
        ),
      );
    });
  }
}
