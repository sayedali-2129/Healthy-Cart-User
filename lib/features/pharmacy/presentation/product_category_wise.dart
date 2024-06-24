import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/grid_product.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyCategoryWiseProductScreen extends StatefulWidget {
  const PharmacyCategoryWiseProductScreen({super.key});

  @override
  State<PharmacyCategoryWiseProductScreen> createState() =>
      _PharmacyCategoryWiseProductScreenState();
}

class _PharmacyCategoryWiseProductScreenState
    extends State<PharmacyCategoryWiseProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final pharmacyProvider = context.read<PharmacyProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        pharmacyProvider.clearPharmacyCategoryProductFetchData();
        pharmacyProvider.getPharmacyCategoryProductDetails();
      },
    );
    _scrollController.addListener(
      () {
        if (_scrollController.position.atEdge &&
            _scrollController.position.pixels != 0 &&
            pharmacyProvider.fetchLoading == false) {
          pharmacyProvider.getPharmacyCategoryProductDetails();
        }
      },
    );
  }

  @override
  void dispose() {
    EasyDebounce.cancel('productcategorysearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverCustomAppbar(
          title: pharmacyProvider.selectedCategory ?? 'Category',
          onBackTap: () {
            EasyNavigation.pop(context: context);
          },
          child: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pharmacyProvider.searchController,
                onChanged: (searchText) {
                  EasyDebounce.debounce(
                    'productcategorysearch',
                    const Duration(milliseconds: 500),
                    () {
                      pharmacyProvider.searchCategoryWiseProduct(
                        searchText: searchText,
                      );
                    },
                  );
                },
                showCursor: false,
                cursorColor: BColors.black,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                  hintText: 'Search products',
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
        (pharmacyProvider.fetchLoading == true &&
                pharmacyProvider.productCategoryWiseList.isEmpty)
            ? const SliverFillRemaining(
                child: Center(
                  child: LoadingIndicater(),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.builder(
                  itemCount: pharmacyProvider.productCategoryWiseList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    mainAxisExtent: 360,
                  ),
                  itemBuilder: (context, index) {
                    return PostCardVertical(
                      productData:
                          pharmacyProvider.productCategoryWiseList[index],
                    );
                  },
                ),
              ),
        if (pharmacyProvider.fetchLoading == false &&
            pharmacyProvider.productCategoryWiseList.isEmpty)
          const ErrorOrNoDataPage(
            text: 'No products found in this category.',
          ),
        SliverToBoxAdapter(
            child: (pharmacyProvider.fetchLoading == true &&
                    pharmacyProvider.productCategoryWiseList.isNotEmpty)
                ? const Center(
                    child: LoadingIndicater(),
                  )
                : null),
      ],
    ));
  }
}
