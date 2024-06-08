import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/ad_pharmacy_slider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/grid_product.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_product_header.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class PharmacyProductScreen extends StatefulWidget {
  const PharmacyProductScreen({super.key});

  @override
  State<PharmacyProductScreen> createState() => _PharmacyProductScreenState();
}

class _PharmacyProductScreenState extends State<PharmacyProductScreen> {
  @override
  void dispose() {
    EasyDebounce.cancel('productsearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
            title: 'Karuna pharmacy',
            onBackTap: () {
              EasyNavigation.pop(context: context);
            },
           
            child: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {},
                    controller: TextEditingController(),
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
                    labId: '',
                    screenWidth: double.infinity,
                  ),
                  ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                mainAxisExtent: 328,
              ),
              itemBuilder: (context, index) {
                return const PostCardVertical();
              },
            ),
          ),
        ],
      ),
    );
  }
}
