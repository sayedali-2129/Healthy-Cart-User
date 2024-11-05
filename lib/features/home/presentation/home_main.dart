import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/view_all_button.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
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
import 'package:healthy_cart_user/features/hospital/presentation/all_categories_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/all_doctors_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/categories_list_card.dart';
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
        hospitalProvider
            .hospitalFetchInitData(
          context: context,
        )
            .whenComplete(
          () {
            hospitalProvider.getHospitalAllCategory();
            homeProvider.getBanner();
          },
        );

        labProvider.labortaryFetchInitData(
          context: context,
        );
        pharmacyProvider.pharmacyFetchInitData(context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer6<HomeProvider, HospitalProvider, LabProvider,
            PharmacyProvider, AuthenticationProvider, LocationProvider>(
        builder: (context, homeProvider, hospitalProvider, labProvider,
            pharmacyProvider, authProvider, locationProvider, _) {
      return Scaffold(
          body: CustomScrollView(
        slivers: [
          MainHomeAppBar(
            searchHint: 'Search',
            locationText:
                "${locationProvider.localsavedHomeplacemark?.localArea},${locationProvider.localsavedHomeplacemark?.district},${locationProvider.localsavedHomeplacemark?.state}",
            locationTap: () async {
              await EasyNavigation.push(
                type: PageTransitionType.topToBottom,
                context: context,
                page: UserLocationSearchWidget(
                  isUserEditProfile: false,
                  locationSetter: 0,
                  onSucess: () {
                    hospitalProvider.hospitalFetchInitData(
                      context: context,
                    );
                    labProvider.labortaryFetchInitData(
                      context: context,
                    );
                    pharmacyProvider.pharmacyFetchInitData(context: context);
                  },
                ),
              );
            },
          ),
          const SliverGap(8),
          if (homeProvider.isLoading == true ||
              hospitalProvider.isFirebaseDataLoding == true ||
              labProvider.isFirebaseDataLoding == true ||
              pharmacyProvider.isFirebaseDataLoding == true ||
              hospitalProvider.isLoading == true)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if ((homeProvider.homeBannerList.isEmpty &&
                  homeProvider.isLoading == false) &&
              (hospitalProvider.isFirebaseDataLoding == false &&
                  hospitalProvider.isLoading == false &&
                  hospitalProvider.hospitalAllCategoryList.isEmpty &&
                  hospitalProvider.hospitalList.isEmpty) &&
              (labProvider.isFirebaseDataLoding == false &&
                  labProvider.labList.isEmpty) &&
              (pharmacyProvider.isFirebaseDataLoding == false &&
                  pharmacyProvider.pharmacyList.isEmpty))
            const SliverFillRemaining(
              child: StillWorkingPage(
                text: "We are still working to get our services to your area.",
              ),
            )
          else
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (homeProvider.homeBannerList.isNotEmpty &&
                      !hospitalProvider.hospitalFetchLoading)
                    FadeInRight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: AdSliderHome(screenWidth: screenwidth),
                      ),
                    ),
                  if (hospitalProvider.hospitalList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
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
                  if (hospitalProvider.hospitalList.isNotEmpty)
                    SizedBox(
                      height: 224,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: hospitalProvider.hospitalList.length > 5
                            ? 5
                            : hospitalProvider.hospitalList.length,
                        separatorBuilder: (context, index) => const Gap(10),
                        itemBuilder: (context, index) => FadeInRight(
                          child: GestureDetector(
                            onTap: () {
                              if (authProvider.auth.currentUser == null) {
                                EasyNavigation.push(
                                    type: PageTransitionType.rightToLeft,
                                    context: context,
                                    page: const LoginScreen());
                                CustomToast.infoToast(
                                    text: 'Login to continue !');
                              } else {
                                if (hospitalProvider
                                        .hospitalList[index].ishospitalON ==
                                    false) {
                                  CustomToast.errorToast(
                                      text:
                                          'This Hospital is not available now!');
                                  return;
                                }

                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    page: HospitalDetails(
                                      hospitalId: hospitalProvider
                                          .hospitalList[index].id!,
                                      categoryIdList: hospitalProvider
                                          .hospitalList[index]
                                          .selectedCategoryId,
                                    ));
                              }
                            },
                            child: HospitalsHorizontalCard(
                              index: index,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (hospitalProvider.hospitalAllCategoryList.isNotEmpty &&
                      hospitalProvider.hospitalList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hospital Categories',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          ViewAllButton(
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
                                  type: PageTransitionType.rightToLeft,
                                  context: context,
                                  page: const AllCategoriesScreen(),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  if (hospitalProvider.hospitalAllCategoryList.isNotEmpty &&
                      hospitalProvider.hospitalList.isNotEmpty)
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              crossAxisCount: 2,
                              mainAxisExtent: 48),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          hospitalProvider.hospitalAllCategoryList.length > 6
                              ? 6
                              : hospitalProvider.hospitalAllCategoryList.length,
                      itemBuilder: (context, index) {
                        final category =
                            hospitalProvider.hospitalAllCategoryList[index];
                        return InkWell(
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
                                page: AllDoctorsScreen(
                                  category: category,
                                ),
                              );
                            }
                          },
                          child: FadeInRight(
                              child: CategoryListCard(category: category)),
                        );
                      },
                    ),
                  if (pharmacyProvider.pharmacyList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pharmacies',
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
                  if (pharmacyProvider.pharmacyList.isNotEmpty)
                    SizedBox(
                      height: 224,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: pharmacyProvider.pharmacyList.length > 5
                            ? 5
                            : pharmacyProvider.pharmacyList.length,
                        separatorBuilder: (context, index) => const Gap(10),
                        itemBuilder: (context, index) => FadeInRight(
                            child: GestureDetector(
                          onTap: () {
                            if (authProvider.auth.currentUser == null) {
                              EasyNavigation.push(
                                  type: PageTransitionType.rightToLeft,
                                  context: context,
                                  page: const LoginScreen());
                              CustomToast.infoToast(
                                  text: 'Login to continue !');
                            } else {
                              if (authProvider
                                      .userFetchlDataFetched!.userName ==
                                  null) {
                                EasyNavigation.push(
                                    type: PageTransitionType.rightToLeft,
                                    context: context,
                                    page: const ProfileSetup());
                              } else {
                                if (pharmacyProvider
                                        .pharmacyList[index].isPharmacyON ==
                                    false) {
                                  CustomToast.errorToast(
                                      text:
                                          'This Pharmacy is not available now!');
                                  return;
                                }

                                pharmacyProvider.setPharmacyIdAndCategoryList(
                                    selectedpharmacyId: pharmacyProvider
                                            .pharmacyList[index].id ??
                                        '',
                                    categoryIdList: pharmacyProvider
                                            .pharmacyList[index]
                                            .selectedCategoryId ??
                                        [],
                                    pharmacy:
                                        pharmacyProvider.pharmacyList[index]);
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
                  if (labProvider.labList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Laboratories',
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
                  if (labProvider.labList.isNotEmpty)
                    ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: labProvider.labList.length > 5
                            ? 5
                            : labProvider.labList.length,
                        separatorBuilder: (context, index) => const Gap(10),
                        itemBuilder: (context, index) => FadeInUp(
                              child: LabListCardHome(
                                index: index,
                                onTap: () {
                                  if (authProvider.auth.currentUser == null) {
                                    EasyNavigation.push(
                                        type: PageTransitionType.rightToLeft,
                                        context: context,
                                        page: const LoginScreen());
                                    CustomToast.infoToast(
                                        text: 'Login to continue !');
                                  } else {
                                  
                                    labProvider.setLabIdAndLab(
                                      selectedLabId:
                                          labProvider.labList[index].id!,
                                      selectedLab: labProvider.labList[index],
                                    );
                                    EasyNavigation.push(
                                      context: context,
                                      type: PageTransitionType.rightToLeft,
                                      page: const LabDetailsScreen(),
                                    );
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
