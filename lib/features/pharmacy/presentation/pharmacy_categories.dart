import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_category_wise.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/vertical_image_text_widget.dart';
import 'package:provider/provider.dart';

class PharmacyCategoriesScreen extends StatelessWidget {
  const PharmacyCategoriesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
            title: 'Categories',
            onBackTap: () {
              EasyNavigation.pop(context: context);
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              itemCount: pharmacyProvider.pharmacyCategoryList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 128),
              itemBuilder: (context, index) {
                return VerticalImageText(
                    onTap: () {
                      pharmacyProvider.setCategoryId(
                          selectedCategoryId:
                              pharmacyProvider.pharmacyCategoryList[index].id ??
                                  '',
                          selectedCategoryName: pharmacyProvider
                              .pharmacyCategoryList[index].category);
                      EasyNavigation.push(
                        context: context,
                        page: const PharmacyCategoryWiseProductScreen(),
                      );
                    },
                    image: pharmacyProvider.pharmacyCategoryList[index].image,
                    title:
                        pharmacyProvider.pharmacyCategoryList[index].category);
              },
            ),
          )
        ],
      ),
    );
  }
}
