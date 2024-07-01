import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_cart.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/ad_pharmacy_slider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/grid_product.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_product_header.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/search_list.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
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
        pharmacyProvider
          ..clearPharmacyAllProductFetchData()
          ..clearCartData()
          ..getpharmacyCategory()
          ..getBanner()
          ..getPharmacyAllProductDetails()
          ..createOrGetProductToUserCart();   
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
      body: CustomScrollView(
        controller: _scrollController,
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
                          context: context,
                          page: const ProductSearchListScreen());
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
                ),
                ),
          ),
            if (pharmacyProvider.fetchLoading == true &&
              pharmacyProvider.productAllList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
       else if (pharmacyProvider.fetchLoading == false &&
                  pharmacyProvider.productAllList.isEmpty)
                const ErrorOrNoDataPage(
                  text: 'No items added to this pharmacy!',
                ),
          const RowProductCategoryWidget(),
          if (pharmacyProvider.bannerImageList.isNotEmpty)
            SliverToBoxAdapter(
              child: FadeInLeft(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AdPharmacySlider(
                    imageUrlList: pharmacyProvider.bannerImageList,
                    autoPlay: (pharmacyProvider.bannerImageList.length <= 1)
                        ? false
                        : true,
                    productImage: false,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          if (pharmacyProvider.productAllList.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  "All Products",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat'),
                ),
              ),
            ),
        
           
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.builder(
                itemCount: pharmacyProvider.productAllList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  mainAxisExtent: 368,
                ),
                itemBuilder: (context, index) {
                  return FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: PostCardVertical(
                      productData: pharmacyProvider.productAllList[index],
                    ),
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 8),
        child: SizedBox(
          height: 56,
          width: 56,
          child: FloatingActionButton(
            elevation: 12,
            tooltip: 'Add to cart',
            clipBehavior: Clip.antiAlias,
            isExtended: true,
            backgroundColor: BColors.darkblue,
            onPressed: () {
              EasyNavigation.push(
                  context: context,
                  type: PageTransitionType.bottomToTop,
                  page: const ProductCartScreen());
            },
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: BColors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
