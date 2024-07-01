import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_order_tabs.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_list_card.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final pharmacyProvider = context.read<PharmacyProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        pharmacyProvider.clearPharmacyFetchData();
        pharmacyProvider.getAllPharmacy();
      },
    );
    _scrollController.addListener(
      () {
        if (_scrollController.position.atEdge &&
            _scrollController.position.pixels != 0 &&
            pharmacyProvider.fetchLoading == false) {
          pharmacyProvider.getAllPharmacy();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    EasyDebounce.cancel('pharmacysearch');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<PharmacyProvider, AuthenticationProvider,
            PharmacyOrderProvider>(
        builder: (context, pharmacyProvider, authProvider, orderProvider, _) {
      final screenwidth = MediaQuery.of(context).size.width;
      return Scaffold(
        body: PopScope(
          onPopInvoked: (didPop) {
            pharmacyProvider.searchController.clear();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              HomeSliverAppbar(
                searchHint: 'Search Pharmacy',
                searchController: pharmacyProvider.searchController,
                onChanged: (searchText) {
                  EasyDebounce.debounce(
                    'pharmacysearch',
                    const Duration(milliseconds: 500),
                    () {
                      pharmacyProvider.searchPharmacy(
                        searchText: searchText,
                      );
                    },
                  );
                },
              ),
              if (pharmacyProvider.fetchLoading == true &&
                  pharmacyProvider.pharmacyList.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: LoadingIndicater()),
                )
              else if (pharmacyProvider.pharmacyList.isEmpty)
                const ErrorOrNoDataPage(
                  text: 'No Pharmacies Found!',
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) => const Gap(10),
                    itemCount: pharmacyProvider.pharmacyList.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        child: PharmacyListCard(
                          screenwidth: screenwidth,
                          pharmacy: pharmacyProvider.pharmacyList[index],
                          onTap: () {
                            if (authProvider.auth.currentUser == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                              CustomToast.infoToast(text: 'Login First');
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
                          },
                        ),
                      );
                    },
                  ),
                ),
              SliverToBoxAdapter(
                  child: (pharmacyProvider.fetchLoading == true &&
                          pharmacyProvider.pharmacyList.isNotEmpty)
                      ? const Center(
                          child: LoadingIndicater(),
                        )
                      : null),
            ],
          ),
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
                  else
                    const Gap(0),
                ],
              ),
      );
    });
  }
}
