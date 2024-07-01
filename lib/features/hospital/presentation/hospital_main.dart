import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_booking_tab.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_details.dart';
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
  final scrollController = ScrollController();

  @override
  void initState() {
    final hospitalProvider = context.read<HospitalProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        hospitalProvider
          ..clearHospitalData()
          ..getAllHospitals();
      },
    );
    hospitalProvider.hospitalInit(scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     final locationProvider = context.read<LocationProvider>();
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer3<HospitalProvider, AuthenticationProvider,
            HospitalBookingProivder>(
        builder: (context, hospitalProvider, authProvider, bookingProvoder, _) {
      return Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            HomeSliverAppbar(
              searchHint: 'Search Hospitals',
              searchController: hospitalProvider.hospitalSearch,
              onChanged: (_) {
                EasyDebounce.debounce(
                  'hospitalsearch',
                  const Duration(milliseconds: 500),
                  () {
                    hospitalProvider.searchHospitals();
                  },
                );
              }, locationText: "${locationProvider.localsavedplacemark?.localArea},${locationProvider.localsavedplacemark?.district},${locationProvider.localsavedplacemark?.state}", locationTap: () { 
                   
                  LoadingLottie.showLoading(
                      context: context, text: 'Please wait...');
                  locationProvider.getLocationPermisson().then(
                    (value) {
                      if (value == true) {
                        EasyNavigation.pop(context: context);
                        EasyNavigation.push(
                            context: context,
                            page: const UserLocationSearchWidget(
                              isUserEditProfile: true,
                            ));
                      }
                    },
                  );
                
               },
            ),
            if (hospitalProvider.hospitalFetchLoading == true &&
                hospitalProvider.hospitalList.isEmpty)
              const SliverFillRemaining(
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
                padding: const EdgeInsets.all(16),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(8),
                  itemCount: hospitalProvider.hospitalList.length,
                  itemBuilder: (context, index) => FadeInUp(
                    child: HospitalMainCard(
                      screenwidth: screenwidth,
                      index: index,
                      onTap: () {
                        if (authProvider.auth.currentUser == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                          CustomToast.infoToast(text: 'Login to continue !');
                        } else {
                          EasyNavigation.push(
                              context: context,
                              type: PageTransitionType.rightToLeft,
                              duration: 250,
                              page: HospitalDetails(
                                hospitalId:
                                    hospitalProvider.hospitalList[index].id!,
                                categoryIdList: hospitalProvider
                                        .hospitalList[index]
                                        .selectedCategoryId ??
                                    [],
                                hospitalIndex: index,
                              ));
                        }
                      },
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
                child: (hospitalProvider.hospitalFetchLoading == true &&
                        hospitalProvider.hospitalList.isNotEmpty)
                    ? const Center(child: LoadingIndicater())
                    : const Gap(0)),
          ],
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
                  if (bookingProvoder.approvedBookings
                      .any((element) => element.isUserAccepted == false))
                    const Positioned(
                      right: 2,
                      top: 2,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.yellow,
                      ),
                    )
                  else
                    const Gap(0),
                ],
              ),
      );
    });
  }
}
