import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_search_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/grid_product.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class ProductSearchListScreen extends StatefulWidget {
  const ProductSearchListScreen({super.key});

  @override
  State<ProductSearchListScreen> createState() =>
      _ProductSearchListScreenState();
}

class _ProductSearchListScreenState extends State<ProductSearchListScreen> {
  @override
  void dispose() {
    EasyDebounce.cancel('productsearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
        return PopScope(
          onPopInvoked: (didPop) {
            pharmacyProvider.clearPharmacyAllProductFetchData();
            pharmacyProvider.getPharmacyAllProductDetails();
          },
          child: CustomScrollView(
            slivers: [
              CustomSliverSearchAppBar(
                  onTapBackButton: () {
                    EasyNavigation.pop(context: context);
                  },
                  searchOnChanged: (searchText) {
                    EasyDebounce.debounce(
                      'productsearch',
                      const Duration(milliseconds: 500),
                      () {
                        pharmacyProvider.searchAllProduct(
                          searchText: searchText,
                        );
                      },
                    );
                  },
                  controller: pharmacyProvider.searchController),
              (pharmacyProvider.fetchLoading == true &&
                      pharmacyProvider.productAllList.isEmpty)
                  ? const SliverFillRemaining(
                      child: Center(
                        child: LoadingIndicater(),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid.builder(
                        itemCount: pharmacyProvider.productAllList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          mainAxisExtent: 360,
                        ),
                        itemBuilder: (context, index) {
                          return PostCardVertical(
                            productData:
                                pharmacyProvider.productAllList[index],
                          );
                        },
                      ),
                    ),
              if (pharmacyProvider.fetchLoading == false &&
                  pharmacyProvider.productAllList.isEmpty)
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        BImage.noDataPng,
                        height: 160,
                        width: 160,
                      ),
                      const Gap(8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No similar product found.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: BColors.black),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}
