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
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_list_card.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PharmaciesMainSearch extends StatefulWidget {
  const PharmaciesMainSearch({super.key});

  @override
  State<PharmaciesMainSearch> createState() => _LaborataryMainSearchState();
}

class _LaborataryMainSearchState extends State<PharmaciesMainSearch> {
  @override
  void dispose() {
    super.dispose();
    EasyDebounce.cancel('pharmasearch');
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer2<PharmacyProvider, AuthenticationProvider>(
        builder: (context, pharmacyProvider, authProvider, _) {
      return Scaffold(
        body: PopScope(
          onPopInvoked: (didPop) {
            pharmacyProvider.clearPharmacyFetchData();
          },
          child: CustomScrollView(
            controller: pharmacyProvider.searchScrollController,
            slivers: [
              CustomSliverSearchAppBar(
                searchHint: 'Search Pharmacies',
                controller: pharmacyProvider.searchController,
                onTapBackButton: () {
                  EasyNavigation.pop(context: context);
                },
                searchOnChanged: (value) {
                  if (value.trim().isEmpty) {
                    pharmacyProvider.clearPharmacyFetchData();
                    return;
                  }
                  EasyDebounce.debounce(
                    'pharmasearch',
                    const Duration(milliseconds: 500),
                    () {
                      pharmacyProvider.searchPharmacy(searchText: value);
                    },
                  );
                },
              ),
              if (pharmacyProvider.fetchLoading == true &&
                  pharmacyProvider.pharmacySearchList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (pharmacyProvider.pharmacySearchList.isEmpty)
                SliverFillRemaining(
                  child: NoDataImageWidget(
                      text: (pharmacyProvider.searchController.text == '')
                          ? 'Search results will be shown here.'
                          : 'No Search results found.'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(12),
                      itemCount: pharmacyProvider.pharmacySearchList.length,
                      itemBuilder: (context, index) {
                        final pharmacyDetails =
                            pharmacyProvider.pharmacySearchList[index];
                        return FadeInUp(
                          child: PharmacyListCard(
                            screenwidth: screenwidth,
                            pharmacy: pharmacyDetails,
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
                                      context: context,
                                      page: const ProfileSetup());
                                } else {
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
                          ),
                        );
                      }),
                ),
              SliverToBoxAdapter(
                  child: (pharmacyProvider.fetchLoading == true &&
                          pharmacyProvider.pharmacySearchList.isNotEmpty)
                      ? const Center(child: LoadingIndicater())
                      : null),
            ],
          ),
        ),
      );
    });
  }
}
