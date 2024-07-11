import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_category_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/category_wise_doctor_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
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
  final scrollController = ScrollController();
  @override
  void initState() {
    final hospitalProvider = context.read<HospitalProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        hospitalProvider.clearAllDoctorsCategoryWiseData();
        hospitalProvider.getAllDoctorsCategoryWise(
            categoryId: widget.category?.id ?? '');
      },
    );

    hospitalProvider.getAllDoctorsCategoryWiseinit(
        scrollController: scrollController,
        categoryId: widget.category?.id ?? '');

    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('doctorSearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Scaffold(
        body: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              hospitalProvider.doctorSearchController.clear();
            }
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverCustomAppbar(
                title: widget.category?.category ?? 'Unknown Category',
                onBackTap: () {
                  Navigator.pop(context);
                },
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: hospitalProvider.doctorSearchController,
                      onChanged: (value) {
                        EasyDebounce.debounce(
                          'doctorSearch',
                          const Duration(microseconds: 500),
                          () {
                            hospitalProvider.searchAllDoctorsCategoryWise(
                                categoryId: widget.category?.id ?? '');
                          },
                        );
                      },
                      showCursor: false,
                      cursorColor: BColors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                        hintText: 'Search Doctor',
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
                  ),
                ),
              ),
              if (hospitalProvider.isLoading == true &&
                  hospitalProvider.categoryWiseDoctorsList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (hospitalProvider.categoryWiseDoctorsList.isEmpty)
                const ErrorOrNoDataPage(text: 'No Doctors Found!')
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
                                  .categoryWiseDoctorsList[doctorIndex])),
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
