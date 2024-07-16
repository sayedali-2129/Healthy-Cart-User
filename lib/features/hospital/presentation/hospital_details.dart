import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/button_widget/view_all_button.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_categories_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_doctors_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/doctor_details_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/ad_slider_hospital.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/vertical_image_text_widget.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalDetails extends StatefulWidget {
  const HospitalDetails(
      {super.key, required this.hospitalId, required this.categoryIdList});

  final String hospitalId;
  final List<String>? categoryIdList;

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<HospitalProvider>()
          ..getHospitalBanner(hospitalId: widget.hospitalId)
          ..getHospitalCategory(categoryIdList: widget.categoryIdList ?? [])
          ..clearDoctorData()
          ..getDoctors(hospitalId: widget.hospitalId);
        context
            .read<PharmacyProvider>()
            .getSinglePharmacy(hospitalPharmacyId: widget.hospitalId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<HospitalProvider, PharmacyProvider,AuthenticationProvider>(
        builder: (context, hospitalProvider, pharmacyProvider,authProvider, _) {
      final hospital = hospitalProvider.hospitalList.firstWhere(
        (element) {
          return element.id == widget.hospitalId;
        },
      );
      return Scaffold(
          body: CustomScrollView(slivers: [
        SliverCustomAppbar(
          title: hospital.hospitalName ?? 'Hospital',
          onBackTap: () {
            Navigator.pop(context);
          },
        ),
        if (hospitalProvider.isLoading == true)
          const SliverFillRemaining(
            child: Center(
              child: LoadingIndicater(),
            ),
          )
        else if (hospitalProvider.isLoading == false &&
            hospitalProvider.hospitalBanner.isEmpty &&
            hospitalProvider.hospitalCategoryList.isEmpty &&
            hospitalProvider.doctorsList.isEmpty)
          const SliverFillRemaining(
              child: StillWorkingPage(
            text:
                "We are still working on our Hospital, will be soon available.",
          ))
        else
          SliverToBoxAdapter(
            child: Column(
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      height: 234,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          CustomCachedNetworkImage(image: hospital.image!),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  BColors.black.withOpacity(0.5),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 16, right: 16, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FadeInDown(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              hospital.hospitalName ?? 'Unknown Name',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: BColors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const Gap(4),
                            Expanded(
                              child: Text(
                                hospital.address ?? 'Unknown Address',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: (pharmacyProvider.hospitalPharmacy != null)
                              ? ButtonWidget(
                                  buttonColor: BColors.buttonGreen,
                                  onPressed: () {
                                    if (authProvider.auth.currentUser == null) {
                                      EasyNavigation.push(
                                          type: PageTransitionType.rightToLeft,
                                          context: context,
                                          page: const LoginScreen());
                                      CustomToast.infoToast(
                                          text: 'Login to continue !');
                                    } else {
                                      if (authProvider.userFetchlDataFetched!
                                              .userName ==
                                          null) {
                                        EasyNavigation.push(
                                            context: context,
                                            page: const ProfileSetup());
                                      } else {
                                        pharmacyProvider
                                            .setPharmacyIdAndCategoryList(
                                                selectedpharmacyId:
                                                    pharmacyProvider
                                                            .hospitalPharmacy
                                                            ?.id ??
                                                        '',
                                                categoryIdList: pharmacyProvider
                                                        .hospitalPharmacy
                                                        ?.selectedCategoryId ??
                                                    [],
                                                pharmacy: pharmacyProvider
                                                        .hospitalPharmacy ??
                                                    PharmacyModel());
                                        EasyNavigation.push(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            context: context,
                                            page:
                                                const PharmacyProductScreen());
                                      }
                                    }
                                  },
                                  buttonHeight: 32,
                                  buttonWidth: 200,
                                  buttonWidget: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Visit Our Pharmacy',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Montserrat',
                                          color: BColors.textBlack,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: BColors.textBlack,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : null),
                    ),
                    if (hospitalProvider.hospitalBanner.isNotEmpty)
                      FadeInRight(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: AdSliderHospital(
                            screenWidth: double.infinity,
                            labId: widget.hospitalId,
                          ),
                        ),
                      ),
                    hospitalProvider.hospitalCategoryList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Our Categories',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                ViewAllButton(
                                  onTap: () {
                                    EasyNavigation.push(
                                        context: context,
                                        type: PageTransitionType.rightToLeft,
                                       
                                        page: HospitalCategoriesScreen(
                                          hospitalDetails: hospital,
                                        ));
                                  },
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const Gap(16),
                    hospitalProvider.hospitalCategoryList.isNotEmpty
                        ? SizedBox(
                            height: 112,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  hospitalProvider.hospitalCategoryList.length >
                                          5
                                      ? 5
                                      : hospitalProvider
                                          .hospitalCategoryList.length,
                              itemBuilder: (context, categoryIndex) {
                                final selectedCategory = hospitalProvider
                                    .hospitalCategoryList[categoryIndex];
                                return FadeInRight(
                                  duration: const Duration(milliseconds: 500),
                                  child: VerticalImageText(
                                      rightPadding: 4,
                                      leftPadding: 2,
                                      onTap: () {
                                        EasyNavigation.push(
                                            context: context,
                                            type:
                                                PageTransitionType.rightToLeft,
                                           
                                            page: HospitalDoctorsScreen(
                                              hospitalDetails: hospital,
                                              category: selectedCategory,
                                              isCategoryWise: true,
                                            ));
                                      },
                                      image: hospitalProvider
                                              .hospitalCategoryList[
                                                  categoryIndex]
                                              .image ??
                                          '',
                                      title: hospitalProvider
                                              .hospitalCategoryList[
                                                  categoryIndex]
                                              .category ??
                                          'Unknown Category'),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                    if (hospitalProvider.doctorsList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Our Doctors',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            ViewAllButton(
                              onTap: () {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    
                                    page: HospitalDoctorsScreen(
                                      isCategoryWise: false,
                                      hospitalDetails: hospital,
                                    ));
                              },
                            )
                          ],
                        ),
                      ),
                    const Gap(8),
                    ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Gap(12),
                        itemCount: hospitalProvider.doctorsList.length > 5
                            ? 5
                            : hospitalProvider.doctorsList.length,
                        itemBuilder: (context, doctorIndex) {

                          return GestureDetector(
                            onTap: () {
                              EasyNavigation.push(
                                  context: context,
                                  page: DoctorDetailsScreen(
                                    doctorModel: hospitalProvider
                                        .doctorsList[doctorIndex],
                                    hospital: hospital,
                                  ),
                                  type: PageTransitionType.rightToLeft,
                                  );
                            },
                            child: FadeInRight(
                              duration: const Duration(milliseconds: 500),
                              child: DoctorCard(
                                  fromHomePage: false,
                                  doctor: hospitalProvider
                                      .doctorsList[doctorIndex]),
                            ),
                          );
                        })
                  ],
                ),
              ],
            ),
          )
      ]));
    });
  }
}
