import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/list_card_pharmacy.dart';
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
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
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
                      return PharmacyListCard(
                        screenwidth: screenwidth,
                        pharmacy: pharmacyProvider.pharmacyList[index],
                        onTap: () {
                          pharmacyProvider.setPharmacyIdAndCategoryList(
                              selectedpharmacyId:
                                  pharmacyProvider.pharmacyList[index].id ?? '',
                              categoryIdList: pharmacyProvider
                                      .pharmacyList[index].selectedCategoryId ??
                                  [],
                              pharmacy: pharmacyProvider.pharmacyList[index]);
                          EasyNavigation.push(
                              type: PageTransitionType.rightToLeft,
                              context: context,
                              page: const PharmacyProductScreen());
                        },
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
      );
    });
  }
}
