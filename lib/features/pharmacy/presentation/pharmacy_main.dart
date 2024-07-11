import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/location_no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_order_tabs.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_search_main.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_list_card.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PharmacyMain extends StatefulWidget {
  const PharmacyMain({super.key});

  @override
  State<PharmacyMain> createState() => _PharmacyMainState();
}

class _PharmacyMainState extends State<PharmacyMain> {
  @override
  void initState() {
    super.initState();
    final pharmacyProvider = context.read<PharmacyProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        pharmacyProvider
          ..clearPharmacyFetchData()
          ..pharmacyFetchInitData(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer4<PharmacyProvider, AuthenticationProvider,
            PharmacyOrderProvider, LocationProvider>(
        builder: (context, pharmacyProvider, authProvider, orderProvider,
            locationProvider, _) {
      return Scaffold(
        body: CustomScrollView(
          controller: pharmacyProvider.mainScrollController,
          slivers: [
            HomeSliverAppbar(
              onSearchTap: () {
                EasyNavigation.push(
                    type: PageTransitionType.topToBottom,
                    context: context,
                    page: const PharmaciesMainSearch());
              },
              locationText:
                  "${locationProvider.locallySavedPharmacyplacemark?.localArea},${locationProvider.locallySavedPharmacyplacemark?.district},${locationProvider.locallySavedPharmacyplacemark?.state}",
              searchHint: 'Search Pharmacies',
              searchController: pharmacyProvider.searchController,
              locationTap: () {
                EasyNavigation.push(
                    context: context,
                    page: UserLocationSearchWidget(
                      isUserEditProfile: false,
                      locationSetter: 3,
                      onSucess: () {
                        pharmacyProvider.pharmacyFetchInitData(
                            context: context);
                      },
                    ));
              },
            ),
            SliverToBoxAdapter(
                child: (pharmacyProvider.pharmacyList.isNotEmpty &&
                        pharmacyProvider.checkNearestPharmacyLocation())
                    ? NoDataInSelectedLocation(
                        locationTitle:
                            '${locationProvider.locallySavedPharmacyplacemark?.localArea}',
                        typeOfService: 'Pharmacies',
                      )
                    : null),
            if (pharmacyProvider.isFirebaseDataLoding == true &&
                pharmacyProvider.pharmacyList.isEmpty)
              const SliverFillRemaining(
                child: Center(child: LoadingIndicater()),
              )
            else if (pharmacyProvider.pharmacyList.isEmpty)
              const ErrorOrNoDataPage(text: 'No Pharmacies Found!')
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(12),
                  itemCount: pharmacyProvider.pharmacyList.length,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      child: PharmacyListCard(
                        screenwidth: screenwidth,
                        pharmacy: pharmacyProvider.pharmacyList[index],
                        onTap: () {
                          if (authProvider.auth.currentUser == null) {
                            EasyNavigation.push(
                                type: PageTransitionType.rightToLeft,
                                context: context,
                                page: const LoginScreen());
                            CustomToast.infoToast(text: 'Login to continue !');
                          } else {
                            if (authProvider.userFetchlDataFetched!.userName ==
                                null) {
                              EasyNavigation.push(
                                  context: context, page: const ProfileSetup());
                            } else {
                              pharmacyProvider.setPharmacyIdAndCategoryList(
                                  selectedpharmacyId:
                                      pharmacyProvider.pharmacyList[index].id ??
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
                  },
                ),
              ),
            SliverToBoxAdapter(
                child: (pharmacyProvider.circularProgressLOading == true &&
                        pharmacyProvider.pharmacyList.isNotEmpty)
                    ? const Center(
                        child: LoadingIndicater(),
                      )
                    : null),
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
                          page: const PharmacyOrdersTab(),
                          type: PageTransitionType.bottomToTop,
                          duration: 200);
                    },
                  ),
                  if (orderProvider.approvedOrderList
                      .any((element) => element.isUserAccepted == false))
                    const Positioned(
                      right: 2,
                      top: 2,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.yellow,
                      ),
                    )
                ],
              ),
      );
    });
  }
}
