import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/doctor_booking_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_details_top_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen(
      {super.key, required this.index, required this.hospitalAddress});
  final int index;
  final String hospitalAddress;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      final doctors = hospitalProvider.doctorsList[index];
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
              onBackTap: () {
                Navigator.pop(context);
              },
              title: doctors.doctorName ?? 'Doctor',
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                  child:
                      DoctorDetailsTopCard(doctors: doctors, isBooking: false)),
            ),
            const SliverGap(10),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: ButtonWidget(
                    buttonHeight: 48,
                    buttonWidth: double.infinity,
                    buttonColor: BColors.mainlightColor,
                    buttonWidget: const Text(
                      'Make An Appoinment',
                      style: TextStyle(
                          color: BColors.white, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      EasyNavigation.push(
                          context: context,
                          page: DoctorBookingScreen(index: index),
                          type: PageTransitionType.rightToLeft,
                          duration: 250);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
