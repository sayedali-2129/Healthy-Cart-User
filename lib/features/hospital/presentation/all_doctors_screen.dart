//import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/location_no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/all_doctors_search.dart';
import 'package:healthy_cart_user/features/hospital/presentation/category_wise_doctor_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key, this.category});
  final HospitalCategoryModel? category;

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  @override
  void initState() {
    final hospitalBookingProivder = context.read<HospitalBookingProivder>();
    final hospitalProvider = context.read<HospitalProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
      //  log(widget.category!.id.toString());
        hospitalProvider.clearAllDoctorsCategoryWiseData();
        hospitalBookingProivder.allDoctorsCategoryWiseFetchInitData(
            context: context, categoryId: widget.category!.id!);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<HospitalBookingProivder, AuthenticationProvider,
            HospitalProvider, LocationProvider>(
        builder: (context, hospitalBookingProivder, authProvider,
            hospitalProvider, locationProvider, _) {
      return Scaffold(
        body: RefreshIndicator(
          color: BColors.darkblue,
          backgroundColor: BColors.white,
          onRefresh: () async {
            hospitalBookingProivder
              ..clearAllDoctorsCategoryWiseLocationData()
              ..allDoctorsCategoryWiseFetchInitData(
                  context: context, categoryId: widget.category?.id ?? '');
          },
          child: CustomScrollView(
            controller: hospitalBookingProivder.mainScrollController,
            slivers: [
              SliverCustomAppbar(
                title: widget.category?.category ?? 'Unknown Category',
                onBackTap: () {
                  Navigator.pop(context);
                },
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(80),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await EasyNavigation.push(
                              type: PageTransitionType.topToBottom,
                              context: context,
                              page: UserLocationSearchWidget(
                                isUserEditProfile: false,
                                locationSetter: 5,
                                onSucess: () {},
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              Text(
                                "${locationProvider.locallySavedDoctorplacemark?.localArea},${locationProvider.locallySavedDoctorplacemark?.district},${locationProvider.locallySavedDoctorplacemark?.state}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.darkblue),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        TextField(
                          onTap: () {
                            EasyNavigation.push(
                                type: PageTransitionType.topToBottom,
                                context: context,
                                page:  AllDoctorsSearchScreen(category: widget.category,));
                          },
                          showCursor: false,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 4, 8, 4),
                            hintText: 'Search Doctors',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(
                              Icons.search_outlined,
                              color: BColors.darkblue,
                            ),
                            filled: true,
                            fillColor: BColors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: (hospitalBookingProivder
                              .allDoctorHomeList.isNotEmpty &&
                          hospitalBookingProivder.checkNearestDoctorLocation())
                      ? NoDataInSelectedLocation(
                          locationTitle:
                              '${locationProvider.locallySavedHospitalplacemark?.localArea}',
                          typeOfService: 'Doctors',
                        )
                      : null),
              if (hospitalBookingProivder.isFirebaseDataLoding == true &&
                  hospitalBookingProivder.allDoctorHomeList.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (hospitalBookingProivder.allDoctorHomeList.isEmpty)
                const SliverFillRemaining(
                  child: NoDataImageWidget(text: 'No Doctors Found'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(12),
                      itemCount:
                          hospitalBookingProivder.allDoctorHomeList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            EasyNavigation.push(
                                context: context,
                                page: CategoryWiseDoctorDetailsScreen(
                                  doctorModel: hospitalBookingProivder
                                      .allDoctorHomeList[index],
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: 250);
                          },
                          child: FadeIn(
                            child: DoctorCard(
                              fromHomePage: true,
                              doctor: hospitalBookingProivder
                                  .allDoctorHomeList[index],
                            ),
                          ),
                        );
                      }),
                ),
              SliverToBoxAdapter(
                  child: (hospitalBookingProivder.circularProgressLOading ==
                              true &&
                          hospitalBookingProivder.allDoctorHomeList.isNotEmpty)
                      ? const Center(child: LoadingIndicater())
                      : null),
            ],
          ),
        ),
      );
    });
  }
}
