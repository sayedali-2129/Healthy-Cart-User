import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/ad_pharmacy_slider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/grid_product.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_product_header.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/search_list.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyProductScreen extends StatefulWidget {
  const PharmacyProductScreen({super.key});

  @override
  State<PharmacyProductScreen> createState() => _PharmacyProductScreenState();
}

class _PharmacyProductScreenState extends State<PharmacyProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final pharmacyProvider = context.read<PharmacyProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        pharmacyProvider.getpharmacyCategory();
        pharmacyProvider.clearPharmacyAllProductFetchData();
        pharmacyProvider.getPharmacyAllProductDetails();
      },
    );
    _scrollController.addListener(
      () {
        if (_scrollController.position.atEdge &&
            _scrollController.position.pixels != 0 &&
            pharmacyProvider.fetchLoading == false) {
          pharmacyProvider.getPharmacyAllProductDetails();
        }
      },
    );
  }

  @override
  void dispose() {
    EasyDebounce.cancel('productsearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Scaffold(
      body: 
         CustomScrollView(
          controller:_scrollController ,
          slivers: [
            SliverCustomAppbar(
              title: pharmacyProvider.selectedpharmacyData?.pharmacyName ??
                  'Pharmacy',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              },
              child: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onTap: () {
                        EasyNavigation.push(
                            context: context, page: const ProductSearchListScreen());
                      },
                      readOnly: true,
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
                  )),
            ),
            const RowProductCategoryWidget(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: BColors.lightGrey,
                  child: const AdPharmacySlider(
                    pharmacyId: '',
                    screenWidth: double.infinity,
                  ),
                ),
              ),
            ),
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
                          productData: pharmacyProvider.productAllList[index],
                        );
                      },
                    ),
                  ),

              SliverToBoxAdapter(
                child: (pharmacyProvider.fetchLoading == true &&
                        pharmacyProvider.productAllList.isNotEmpty)
                    ? const Center(
                        child: LoadingIndicater(),
                      )
                    : null),
          ],
        )
    );
  }
}
