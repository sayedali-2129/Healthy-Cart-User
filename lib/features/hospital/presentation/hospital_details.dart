import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/all_doctors_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/doctor_details_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/ad_slider_hospital.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/vertical_image_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalDetails extends StatefulWidget {
  const HospitalDetails(
      {super.key,
      required this.hospitalIndex,
      required this.hospitalId,
      required this.categoryIdList});
  final int hospitalIndex;
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
          ..getDoctors(hospitalId: widget.hospitalId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      final hospital = hospitalProvider.hospitalList[widget.hospitalIndex];
      return Scaffold(
          body: CustomScrollView(slivers: [
        SliverCustomAppbar(
          title: hospital.hospitalName ?? 'Hospital',
          onBackTap: () {
            Navigator.pop(context);
          },
        ),
        hospitalProvider.isLoading == true
            ? const SliverFillRemaining(
                child: Center(child: LoadingIndicater()))
            : SliverToBoxAdapter(
                child: Column(
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        height: 234,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomCachedNetworkImage(image: hospital.image!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FadeInDown(
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  hospital.hospitalName ?? 'No Name',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: BColors.black),
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          FadeInDown(
                            duration: const Duration(milliseconds: 500),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined),
                                const Gap(5),
                                Expanded(
                                  child: Text(
                                    hospital.address ?? 'No Address',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          FadeInRight(
                            duration: const Duration(milliseconds: 500),
                            child: AdSliderHospital(
                              screenWidth: double.infinity,
                              labId: widget.hospitalId,
                            ),
                          ),
                          const Gap(8),
                          hospitalProvider.hospitalCategoryList.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Our Categories',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'View all',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: BColors.buttonLightBlue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                )
                              : const Gap(0),
                          const Gap(12),
                          hospitalProvider.hospitalCategoryList.isNotEmpty
                              ? SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: hospitalProvider
                                        .hospitalCategoryList.length,
                                    itemBuilder: (context, categoryIndex) {
                                      return FadeInRight(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: VerticalImageText(
                                            rightPadding: 8,
                                            leftPadding: 0,
                                            onTap: () {
                                              // EasyNavigation.push(
                                              //     context: context,
                                              //     page:
                                              //         const PharmacyCategoryWiseProductScreen());
                                            },
                                            image: hospitalProvider
                                                .hospitalCategoryList[
                                                    categoryIndex]
                                                .image!,
                                            title: hospitalProvider
                                                .hospitalCategoryList[
                                                    categoryIndex]
                                                .category!),
                                      );
                                    },
                                  ),
                                )
                              : const Gap(0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Our Doctors',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                onTap: () {
                                  EasyNavigation.push(
                                      context: context,
                                      type: PageTransitionType.rightToLeft,
                                      duration: 250,
                                      page: AllDoctorsScreen(
                                        hospitalIndex: widget.hospitalIndex,
                                        hospitalId: widget.hospitalId,
                                      ));
                                },
                                child: const Text(
                                  'View all',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: BColors.buttonLightBlue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Gap(10),
                            itemCount: hospitalProvider.doctorsList.length > 5
                                ? 5
                                : hospitalProvider.doctorsList.length,
                            itemBuilder: (context, doctorIndex) =>
                                GestureDetector(
                              onTap: () {
                                EasyNavigation.push(
                                    context: context,
                                    page: DoctorDetailsScreen(
                                      hospitalIndex: widget.hospitalIndex,
                                      doctorIndex: doctorIndex,
                                      hospitalAddress: hospital.address!,
                                    ),
                                    type: PageTransitionType.rightToLeft,
                                    duration: 250);
                              },
                              child: DoctorCard(
                                index: doctorIndex,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
      ]));
    });
  }
}
