import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_search_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/category_wise_doctor_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AllDoctorsSearchScreen extends StatefulWidget {
  const AllDoctorsSearchScreen({super.key, this.category});

  final HospitalCategoryModel? category;

  @override
  State<AllDoctorsSearchScreen> createState() => _AllDoctorsSearchScreenState();
}

class _AllDoctorsSearchScreenState extends State<AllDoctorsSearchScreen> {
  @override
  void dispose() {
    EasyDebounce.cancel('doctorSearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.category!.id.toString(), name: '----------------------');
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Scaffold(
        body: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              hospitalProvider.clearAllDoctorsCategoryWiseData();
            }
          },
          child: CustomScrollView(
            controller: hospitalProvider.doctorSearchScrollController,
            slivers: [
              CustomSliverSearchAppBar(
                searchHint: 'Search Doctors',
                controller: hospitalProvider.doctorSearchController,
                onTapBackButton: () {
                  EasyNavigation.pop(context: context);
                },
                searchOnChanged: (value) {
                  if (value.trim().isEmpty) {
                    hospitalProvider.clearAllDoctorsCategoryWiseData();
                    return;
                  }
                  EasyDebounce.debounce(
                    'doctorSearch',
                    const Duration(microseconds: 500),
                    () {
                      hospitalProvider.searchAllDoctorsCategoryWise(
                          categoryId: widget.category?.id ?? '');
                    },
                  );
                },
              ),
              if (hospitalProvider.isLoading == true &&
                  hospitalProvider.categoryWiseDoctorsList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (hospitalProvider.categoryWiseDoctorsList.isEmpty)
                SliverFillRemaining(
                    child: NoDataImageWidget(
                        text:
                            (hospitalProvider.doctorSearchController.text == '')
                                ? 'Search results will be shown here.'
                                : 'No Search results found.'))
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, doctorIndex) => const Gap(10),
                    itemCount: hospitalProvider.categoryWiseDoctorsList.length,
                    itemBuilder: (context, doctorIndex) => GestureDetector(
                      onTap: () {
                        EasyNavigation.push(
                            context: context,
                            page: CategoryWiseDoctorDetailsScreen(
                              doctorModel: hospitalProvider
                                  .categoryWiseDoctorsList[doctorIndex],
                            ),
                            type: PageTransitionType.rightToLeft,
                            duration: 250);
                      },
                      child: FadeIn(
                        child: DoctorCard(
                            fromHomePage: true,
                            doctor: hospitalProvider
                                .categoryWiseDoctorsList[doctorIndex]),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                  child: (hospitalProvider.isLoading == true &&
                          hospitalProvider.categoryWiseDoctorsList.isNotEmpty)
                      ? const Center(child: LoadingIndicater())
                      : null),
            ],
          ),
        ),
      );
    });
  }
}
