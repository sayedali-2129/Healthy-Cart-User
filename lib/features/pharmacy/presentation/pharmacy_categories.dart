import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/vertical_image_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class PharmacyCategoriesScreen extends StatelessWidget {
  const PharmacyCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              itemCount: 10,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 128),
              itemBuilder: (context, index) {
                return VerticalImageText(
                    image: BImage.loginImage, title: 'Categoriess');
              },
            ),
          )
        ],
      ),
    );
  }
}
