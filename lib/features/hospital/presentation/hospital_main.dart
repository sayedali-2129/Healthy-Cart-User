import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/location_no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_booking_tab.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_search_main.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hospital_main_card.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalMain extends StatefulWidget {
  const HospitalMain({super.key});

  @override
  State<HospitalMain> createState() => _HospitalMainState();
}

class _HospitalMainState extends State<HospitalMain> {
  @override
  void initState() {
    final hospitalProvider = context.read<HospitalProvider>();
    final bookingProvider = context.read<HospitalBookingProivder>();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        hospitalProvider.clearHospitalData();
        hospitalProvider.hospitalFetchInitData(context: context);
        if (userId != null) {
          bookingProvider.getSingleOrderDoc(userId: userId);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer4<HospitalProvider, AuthenticationProvider,
            HospitalBookingProivder, LocationProvider>(
        builder: (context, hospitalProvider, authProvider, bookingProvider,
            locationProvider, _) {
      return Scaffold(
        body: RefreshIndicator(
          color: BColors.darkblue,
          backgroundColor: BColors.white,
          onRefresh: () async {
            hospitalProvider
              ..clearHospitalLocationData()
              ..hospitalFetchInitData(context: context);
          },
          child: CustomScrollView(
            controller: hospitalProvider.mainScrollController,
            slivers: [
              HomeSliverAppbar(
                onSearchTap: () {
                  EasyNavigation.push(
                      type: PageTransitionType.topToBottom,
                      context: context,
                      page: const HospitalsMainSearch());
                },
                searchHint: 'Search Hospitals',
                locationText:
                    "${locationProvider.locallySavedHospitalplacemark?.localArea},${locationProvider.locallySavedHospitalplacemark?.district},${locationProvider.locallySavedHospitalplacemark?.state}",
                locationTap: () async {
                  await EasyNavigation.push(
                    type: PageTransitionType.topToBottom,
                    context: context,
                    page: UserLocationSearchWidget(
                      isUserEditProfile: false,
                      locationSetter: 1,
                      onSucess: () {
                        hospitalProvider.hospitalFetchInitData(
                          context: context,
                        );
                      },
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                  child: (hospitalProvider.hospitalList.isNotEmpty &&
                          hospitalProvider.checkNearestHospitalLocation())
                      ? NoDataInSelectedLocation(
                          locationTitle:
                              '${locationProvider.locallySavedHospitalplacemark?.localArea}',
                          typeOfService: 'Hospitals',
                        )
                      : null),
              if (hospitalProvider.isFirebaseDataLoding == true &&
                  hospitalProvider.hospitalList.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (hospitalProvider.hospitalList.isEmpty)
                const SliverFillRemaining(
                  child: NoDataImageWidget(text: 'No Hospitals Found'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(12),
                      itemCount: hospitalProvider.hospitalList.length,
                      itemBuilder: (context, index) {
                        return FadeInUp(
                          child: HospitalMainCard(
                            screenwidth: screenwidth,
                            hospital: hospitalProvider.hospitalList[index],
                            onTap: () {
                              if (authProvider.auth.currentUser == null) {
                                EasyNavigation.push(
                                    type: PageTransitionType.rightToLeft,
                                    context: context,
                                    page: const LoginScreen());
                                CustomToast.infoToast(
                                    text: 'Login to continue !');
                              } else {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    duration: 250,
                                    page: HospitalDetails(
                                      hospitalId: hospitalProvider
                                          .hospitalList[index].id!,
                                      categoryIdList: hospitalProvider
                                              .hospitalList[index]
                                              .selectedCategoryId ??
                                          [],
                                    ));
                              }
                            },
                          ),
                        );
                      }),
                ),
              SliverToBoxAdapter(
                  child: (hospitalProvider.circularProgressLOading == true &&
                          hospitalProvider.hospitalList.isNotEmpty)
                      ? const Center(child: LoadingIndicater())
                      : null),
            ],
          ),
        ),
        floatingActionButton: authProvider.auth.currentUser == null
            ? null
            : Stack(
                children: [
                  FloatingActionButton(
                      backgroundColor: BColors.darkblue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Image.asset(
                        color: BColors.white,
                        BIcon.calenderIcon,
                        scale: 3.2,
                      ),
                      onPressed: () {
                        EasyNavigation.push(
                            context: context,
                            page: const HospitalBookingTab(),
                            type: PageTransitionType.bottomToTop,
                            duration: 200);
                      }),
                  if (bookingProvider.singleOrderDoc != null)
                    const Positioned(
                      right: 2,
                      top: 2,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.yellow,
                      ),
                    )
                ],
              ),
      );
    });
  }
}
