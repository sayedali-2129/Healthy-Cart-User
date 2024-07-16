
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
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/doctor_details_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalDoctorsScreen extends StatefulWidget {
  const HospitalDoctorsScreen(
      {super.key,
      required this.isCategoryWise,
      required this.hospitalDetails,  this.category});

  final HospitalModel hospitalDetails;
  final HospitalCategoryModel? category;
  final bool isCategoryWise;

  @override
  State<HospitalDoctorsScreen> createState() => _HospitalDoctorsScreenState();
}

class _HospitalDoctorsScreenState extends State<HospitalDoctorsScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    final hospitalProvider = context.read<HospitalProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.isCategoryWise == true) {
          // log(widget.category?.id ?? 'null');
          hospitalProvider.getCategoryWiseDoctor(
              hospitalId: widget.hospitalDetails.id ?? '',
              categoryId: widget.category?.id ?? '');
        } else {
          context.read<HospitalProvider>()
            ..clearDoctorData()
            ..getDoctors(hospitalId: widget.hospitalDetails.id ?? '');
        }
      },
    );

    hospitalProvider.doctorinit(
        scrollController: scrollController,
        hospitalId: widget.hospitalDetails.id ?? '');

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
              hospitalProvider.clearDoctorData();
              hospitalProvider.getDoctors(
                  hospitalId: widget.hospitalDetails.id ?? '');
            }
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverCustomAppbar(
                title: widget.isCategoryWise == true
                    ? widget.category?.category ??''
                    : 'All Doctors',
                onBackTap: () {
                  Navigator.pop(context);
                },
                child: widget.isCategoryWise == true
                    ? null
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(64),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: hospitalProvider.doctorSearchController,
                            onChanged: (value) {
                              EasyDebounce.debounce(
                                'doctorSearch',
                                const Duration(milliseconds: 500),
                                () {
                                  hospitalProvider.searchDoctor(
                                      hospitalId:
                                          widget.hospitalDetails.id ?? '');
                                },
                              );
                            },
                            showCursor: false,
                            cursorColor: BColors.black,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 4, 8, 4),
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
                  hospitalProvider.doctorsList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (hospitalProvider.doctorsList.isEmpty)
                const ErrorOrNoDataPage(text: 'No Doctors Found!')
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, doctorIndex) => const Gap(10),
                    itemCount: hospitalProvider.doctorsList.length,
                    itemBuilder: (context, doctorIndex) => GestureDetector(
                      onTap: () {
                        EasyNavigation.push(
                            context: context,
                            page: DoctorDetailsScreen(
                              hospital:widget.hospitalDetails ,
                              doctorModel:
                                  hospitalProvider.doctorsList[doctorIndex],
                            ),
                            type: PageTransitionType.rightToLeft,
                            );
                      },
                      child: FadeIn(child: DoctorCard(
                        fromHomePage: false,
                        doctor: hospitalProvider.doctorsList[doctorIndex])),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                  child: (hospitalProvider.isLoading == true &&
                          hospitalProvider.doctorsList.isNotEmpty)
                      ? const Center(child: LoadingIndicater())
                      :null),
            ],
          ),
        ),
      );
    });
  }
}
