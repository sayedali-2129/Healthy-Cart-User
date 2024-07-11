import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_search_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hospital_main_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalsMainSearch extends StatefulWidget {
  const HospitalsMainSearch({super.key});

  @override
  State<HospitalsMainSearch> createState() => _HospitalsMainSearchState();
}

class _HospitalsMainSearchState extends State<HospitalsMainSearch> {
  @override
  void dispose() {
    super.dispose();
    EasyDebounce.cancel('hospitalsearch');
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer2<HospitalProvider, AuthenticationProvider>(
        builder: (context, hospitalProvider, authProvider, _) {
      return Scaffold(
        body: PopScope(
          onPopInvoked: (didPop) {
            hospitalProvider.clearHospitalData();
          },
          child: CustomScrollView(
            controller: hospitalProvider.searchScrollController,
            slivers: [
              CustomSliverSearchAppBar(
                
                searchHint: 'Search Hospitals',
                controller: hospitalProvider.hospitalSearchController,
                onTapBackButton: () {
                  EasyNavigation.pop(context: context);
                },
                searchOnChanged: (value) {
                  if (value.trim().isEmpty) {
                        hospitalProvider.clearHospitalData();
                    return;
                  }
                  EasyDebounce.debounce(
                    'hospitalsearch',
                    const Duration(milliseconds: 500),
                    () {
                      hospitalProvider.searchHospitals();
                    },
                  );
                },
              ),
              if (hospitalProvider.hospitalFetchLoading == true &&
                  hospitalProvider.hospitalListSearch.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (hospitalProvider.hospitalListSearch.isEmpty)
                 SliverFillRemaining(
                  child: NoDataImageWidget(text:(hospitalProvider.hospitalSearchController.text == '')? 'Search results will be shown here.' : 'No Search results found.'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(12),
                      itemCount: hospitalProvider.hospitalListSearch.length,
                      itemBuilder: (context, index) {
                        final hospitalDetails =
                            hospitalProvider.hospitalListSearch[index];
                        return FadeInUp(
                          child: HospitalMainCard(
                            screenwidth: screenwidth,
                            hospital: hospitalDetails,
                            onTap: () {
                              if (authProvider.auth.currentUser == null) {
                               EasyNavigation.push(
                            type: PageTransitionType.rightToLeft,
                            context: context, page:const LoginScreen() );
                                CustomToast.infoToast(
                                    text: 'Login to continue !');
                              } else {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    duration: 250,
                                    page: HospitalDetails(
                                      hospitalId: hospitalDetails.id!,
                                      categoryIdList:
                                          hospitalDetails.selectedCategoryId ??
                                              [],
                                    ));
                              }
                            },
                          ),
                        );
                      }),
                ),
              SliverToBoxAdapter(
                child: (hospitalProvider.hospitalFetchLoading == true && hospitalProvider.hospitalListSearch.isNotEmpty)
                    ? const Center(child: LoadingIndicater())
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
