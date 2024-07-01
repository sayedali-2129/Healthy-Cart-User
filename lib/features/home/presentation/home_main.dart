import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/view_all_button.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/home/application/provider/home_provider.dart';
import 'package:healthy_cart_user/features/home/presentation/widgets/ad_slider_home.dart';
import 'package:healthy_cart_user/features/home/presentation/widgets/hospital_horizontal_card.dart';
import 'package:healthy_cart_user/features/home/presentation/widgets/lab_list_card_home.dart';
import 'package:healthy_cart_user/features/home/presentation/widgets/pharmacy_horizontal_card.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_details.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_details_screen.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomeMain extends StatefulWidget {
  const HomeMain(
      {super.key,
      required this.currentTab,
      required this.onNavigateToHospitalTab,
      required this.onNavigateToLaboratoryTab,
      required this.onNavigateToPharmacyTab});
  final int currentTab;
  final VoidCallback onNavigateToHospitalTab;
  final VoidCallback onNavigateToLaboratoryTab;
  final VoidCallback onNavigateToPharmacyTab;

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  @override
  void initState() {
    final homeProvider = context.read<HomeProvider>();
    final hospitalProvider = context.read<HospitalProvider>();
    final labProvider = context.read<LabProvider>();
    final pharmacyProvider = context.read<PharmacyProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        hospitalProvider.getAllHospitals();
        labProvider.getLabs();
        pharmacyProvider.getAllPharmacy();
        homeProvider.getBanner();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        final locationProvider = context.read<LocationProvider>();
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer5<HomeProvider, HospitalProvider, LabProvider,
            PharmacyProvider, AuthenticationProvider>(
        builder: (context, homeProvider, hospitalProvier, labProvider,
            pharmacyProvider, authProvider, _) {
      return Scaffold(
          body: CustomScrollView(
        slivers: [
          MainHomeAppBar(
            searchHint: 'Search',
            locationText: "${locationProvider.localsavedplacemark?.localArea},${locationProvider.localsavedplacemark?.district},${locationProvider.localsavedplacemark?.state}",
            locationTap: ()  {
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
          const SliverGap(10),
          if (homeProvider.isLoading == true &&
              hospitalProvier.hospitalFetchLoading == true &&
              labProvider.labFetchLoading == true &&
              pharmacyProvider.fetchLoading == true &&
              labProvider.labList.isEmpty &&
              pharmacyProvider.pharmacyList.isEmpty &&
              homeProvider.homeBannerList.isEmpty &&
              hospitalProvier.hospitalList.isEmpty)
            const SliverFillRemaining(child: Center(child: LoadingIndicater()))
          else
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FadeInRight(
                        child: AdSliderHome(screenWidth: screenwidth)),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hospitals',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        ViewAllButton(
                          onTap: () {
                            widget.onNavigateToHospitalTab();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      itemCount: hospitalProvier.hospitalList.length > 5
                          ? 5
                          : hospitalProvier.hospitalList.length,
                      separatorBuilder: (context, index) => const Gap(10),
                      itemBuilder: (context, index) => FadeInRight(
                          child: GestureDetector(
                        onTap: () {
                          if (authProvider.auth.currentUser == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                            CustomToast.infoToast(text: 'Login to continue !');
                          } else {
                            hospitalProvier.hospitalList[index].ishospitalON ==
                                    false
                                ? CustomToast.errorToast(
                                    text: 'This Hospital is not available now!')
                                : EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    duration: 250,
                                    page: HospitalDetails(
                                      hospitalId: hospitalProvier
                                          .hospitalList[index].id!,
                                      categoryIdList: hospitalProvier
                                          .hospitalList[index]
                                          .selectedCategoryId,
                                      hospitalIndex: index,
                                    ));
                          }
                        },
                        child: HospitalsHorizontalCard(
                          index: index,
                        ),
                      )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pharmacy',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        ViewAllButton(
                          onTap: () {
                            widget.onNavigateToPharmacyTab();
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      scrollDirection: Axis.horizontal,
                      itemCount: pharmacyProvider.pharmacyList.length > 5
                          ? 5
                          : pharmacyProvider.pharmacyList.length,
                      separatorBuilder: (context, index) => const Gap(10),
                      itemBuilder: (context, index) => FadeInRight(
                          child: GestureDetector(
                        onTap: () {
                          if (authProvider.auth.currentUser == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                            CustomToast.infoToast(text: 'Login to continue !');
                          } else {
                            if (authProvider.userFetchlDataFetched!.userName ==
                                null) {
                              EasyNavigation.push(
                                  context: context, page: ProfileSetup());
                            } else {
                              pharmacyProvider
                                          .pharmacyList[index].isPharmacyON ==
                                      false
                                  ? CustomToast.errorToast(
                                      text:
                                          'This Pharmacy is not available now!')
                                  : pharmacyProvider
                                      .setPharmacyIdAndCategoryList(
                                          selectedpharmacyId: pharmacyProvider
                                                  .pharmacyList[index].id ??
                                              '',
                                          categoryIdList: pharmacyProvider
                                                  .pharmacyList[index]
                                                  .selectedCategoryId ??
                                              [],
                                          pharmacy: pharmacyProvider
                                              .pharmacyList[index]);
                              EasyNavigation.push(
                                  type: PageTransitionType.rightToLeft,
                                  context: context,
                                  page: const PharmacyProductScreen());
                            }
                          }
                        },
                        child: PharmacyHorizontalCard(
                          index: index,
                        ),
                      )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Laboratory',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        ViewAllButton(
                          onTap: () {
                            widget.onNavigateToLaboratoryTab();
                          },
                        )
                      ],
                    ),
                  ),

                  /* ---------------------------------- LABS ---------------------------------- */
                  ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: labProvider.labList.length > 5
                          ? 5
                          : labProvider.labList.length,
                      separatorBuilder: (context, index) => const Gap(10),
                      itemBuilder: (context, index) => FadeInRight(
                            child: LabListCardHome(
                              index: index,
                              onTap: () {
                                if (authProvider.auth.currentUser == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                  CustomToast.infoToast(
                                      text: 'Login to continue !');
                                } else {
                                  EasyNavigation.push(
                                      context: context,
                                      type: PageTransitionType.rightToLeft,
                                      duration: 250,
                                      page: LabDetailsScreen(
                                        labId: labProvider.labList[index].id!,
                                        index: index,
                                      ));
                                }
                              },
                            ),
                          )),
                ],
              ),
            )
        ],
      ));
    });
  }
}
