import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/ad_pharmacy_slider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/image_show_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

import 'package:provider/provider.dart';

class GalleryImagePicker extends StatelessWidget {
  const GalleryImagePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        AdPharmacySlider(
          imageUrlList: pharmacyProvider.productImageUrlList,
          autoPlay: false,
          productImage: true,
          fit: BoxFit.contain,
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 56,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: pharmacyProvider.productImageUrlList.isEmpty ? 1 : pharmacyProvider.productImageUrlList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    decoration: (pharmacyProvider.selectedIndex == index)
                        ? BoxDecoration(
                            border: Border.all(
                              color: BColors.mainlightColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8))
                        : null,
                    child: Material(
                      color: BColors.white,
                      surfaceTintColor: BColors.white,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: ProductImageShowerWidget(
                        addTap: () {
                         
                          pharmacyProvider.selectedImageIndex(index);
                        },
                        height: 56,
                        width: 64,
                        child:pharmacyProvider.productImageUrlList.isNotEmpty? CustomCachedNetworkImage(
                          image: pharmacyProvider.productImageUrlList[index],
                          fit: BoxFit.fitHeight,
                        ): Image.asset(BImage.healthycartText, fit: BoxFit.contain,)
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ]);
    });
  }
}
