import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/patient_details_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_details_top_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DoctorBookingScreen extends StatelessWidget {
  const DoctorBookingScreen({
    super.key, required this.hospital, required this.doctorModel,

  });
  final HospitalModel hospital;
  final DoctorModel doctorModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      final doctorDetail = doctorModel;
      return PopScope(
        onPopInvoked: (didPop) {
          hospitalProvider.selectedSlot = null;
          hospitalProvider.seletedBookingDate = null;
        },
        child: Scaffold(
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
              'Booking',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorDetailsTopCard(doctors: doctorDetail, isBooking: true),
                  const Gap(20),
                  const Text("Choose Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const Gap(10),
                  DatePicker(
                    DateTime.now(),
                    inactiveDates: hospitalProvider.findAllSundaysFromNow(30),
                    deactivatedColor: BColors.red,
                    onDateChange: (selectedDate) {
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                      hospitalProvider.seletedBookingDate = formattedDate;
                    },
                    daysCount: 30,
                    initialSelectedDate: null,
                    selectionColor: BColors.mainlightColor,
                    height: 90,
                  ),
                  const Gap(10),
                  const Text("Choose Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const Gap(10),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 50),
                    itemCount: doctorDetail.doctorTimeList!.length,
                    itemBuilder: (context, timeIndex) {
                      String timeSlot = doctorDetail.doctorTimeList![timeIndex];
                      bool isSelected =
                          hospitalProvider.selectedSlot == timeSlot;
                      return GestureDetector(
                        onTap: () {
                          hospitalProvider.setTimeSlot(timeSlot);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? BColors.mainlightColor
                                  : BColors.lightGrey.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                doctorDetail.doctorTimeList![timeIndex],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? BColors.white
                                      : BColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              if (hospitalProvider.selectedSlot == null ||
                  hospitalProvider.seletedBookingDate == null) {
                CustomToast.infoToast(text: 'Please select date and time');
              } else {
                log(hospitalProvider.selectedSlot!);
                log(hospitalProvider.seletedBookingDate!);
                EasyNavigation.push(
                    context: context,
                    page: PatientDetailsScreen(
                      selectedDoctor: doctorDetail,
                      hospital: hospital,
                      
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: 250);
              }
            },
            child: Container(
                height: 60,
                color: BColors.mainlightColor,
                child: const Center(
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: BColors.white),
                  ),
                )),
          ),
        ),
      );
    });
  }
}
