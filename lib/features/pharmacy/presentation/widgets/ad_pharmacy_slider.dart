import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class AdPharmacySlider extends StatelessWidget {
  const AdPharmacySlider({
    super.key,
    required this.imageUrlList,
    required this.autoPlay,
    required this.productImage,
    required this.fit,
  });
  final List<String> imageUrlList;
  final bool autoPlay;
  final bool productImage;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return (pharmacyProvider.fetchLoading)
          ? Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              height: 202,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: BColors.darkblue,
                ),
              ))
          : CarouselSlider.builder(
              itemCount: imageUrlList.length,
              itemBuilder: (context, index, realIndex) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Material(
                  color: BColors.white,
                  surfaceTintColor: BColors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 3,
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      width: double.infinity,
                      height: 188,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CustomCachedNetworkImage(
                        image: productImage
                            ? imageUrlList[pharmacyProvider.selectedIndex]
                            : imageUrlList[index],
                        fit: fit,
                      )),
                ),
              ),
              options: CarouselOptions(
                enlargeCenterPage: true,
                viewportFraction: 1,
                initialPage: 0,
                autoPlay: autoPlay,
                autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                onPageChanged: (index, reason) {
                  if(productImage) pharmacyProvider.selectedImageIndex(index);
                },
              ),
            );
    });
  }
}
