import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/doctor_booking_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_details_top_card.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen(
      {super.key,
      required this.doctorIndex,
      required this.hospitalAddress,
      required this.hospitalIndex,
      required this.doctorModel});
  final int doctorIndex;
  final String hospitalAddress;
  final int hospitalIndex;
  final DoctorModel doctorModel;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<HospitalProvider>().getCategoryWiseDoctor(
            hospitalId: widget.doctorModel.hospitalId!,
            categoryId: widget.doctorModel.categoryId!);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HospitalProvider, AuthenticationProvider>(
        builder: (context, hospitalProvider, authProvider, _) {
      // final doctors = hospitalProvider.doctorsList[widget.doctorIndex];
      return PopScope(
        onPopInvoked: (didPop) {
          hospitalProvider.clearDoctorData();
          hospitalProvider.getDoctors(
              hospitalId: widget.doctorModel.hospitalId!);
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverCustomAppbar(
                onBackTap: () {
                  Navigator.pop(context);
                },
                title: widget.doctorModel.doctorName ?? 'Doctor',
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                    child: DoctorDetailsTopCard(
                        doctors: widget.doctorModel, isBooking: false)),
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
                        if (authProvider.userFetchlDataFetched!.userName ==
                            null) {
                          EasyNavigation.push(
                              type: PageTransitionType.rightToLeft,
                              duration: 250,
                              context: context,
                              page: ProfileSetup());
                          CustomToast.infoToast(text: 'Fill user details');
                        } else {
                          EasyNavigation.push(
                              context: context,
                              page: DoctorBookingScreen(
                                  hospitalIndex: widget.hospitalIndex,
                                  doctorIndex: widget.doctorIndex),
                              type: PageTransitionType.rightToLeft,
                              duration: 250);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SliverGap(30),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Gap(12),
                      Text(
                        'Related Doctors',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              if (hospitalProvider.isLoading == true &&
                  hospitalProvider.doctorsList.isEmpty)
                const SliverFillRemaining(
                    child: Center(child: LoadingIndicater()))
              else if (hospitalProvider.doctorsList.isEmpty)
                const SliverFillRemaining(
                    child: Center(
                  child: Text('No Related Doctors Found'),
                ))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) => const Gap(5),
                    itemCount: hospitalProvider.doctorsList.length,
                    itemBuilder: (context, index) {
                      final doctor = hospitalProvider.doctorsList[index];

                      if (doctor.id == widget.doctorModel.id) {
                        return const SizedBox.shrink();
                      } else {
                        return FadeIn(child: DoctorCard(index: index));
                      }
                    },
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
