import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_details_top_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class DoctorBookingScreen extends StatelessWidget {
  const DoctorBookingScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      final doctors = hospitalProvider.doctorsList[index];
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
            'Booking',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorDetailsTopCard(doctors: doctors, isBooking: true),
              const Gap(20),
              const Text("Choose Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              const Gap(10),
              DatePicker(
                DateTime.now(),
                onDateChange: (selectedDate) {},
                daysCount: 30,
                initialSelectedDate: DateTime.now(),
                selectionColor: BColors.mainlightColor,
                height: 90,
              ),
              const Gap(10),
              const Text("Choose Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              Gap(10),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 50),
                itemCount: doctors.doctorTimeList!.length,
                itemBuilder: (context, timeIndex) {
                  String timeSlot = doctors.doctorTimeList![timeIndex];
                  bool isSelected = hospitalProvider.selectedSlot == timeSlot;
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
                            doctors.doctorTimeList![timeIndex],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? BColors.white : BColors.black,
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
        bottomNavigationBar: GestureDetector(
          onTap: () {},
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
