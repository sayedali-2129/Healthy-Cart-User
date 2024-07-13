import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/home/application/provider/home_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class AdSliderHome extends StatefulWidget {
  const AdSliderHome({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<AdSliderHome> createState() => _AdSliderHomeState();
}

class _AdSliderHomeState extends State<AdSliderHome> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, _) {
      if (homeProvider.homeBannerList.isEmpty) {
        return const SizedBox();
      } else {
        return CarouselSlider.builder(
          itemCount: homeProvider.homeBannerList.length,
          itemBuilder: (context, index, realIndex) => Container(
            margin:  const EdgeInsets.symmetric(horizontal: 4),
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            height: 202,
            decoration: BoxDecoration(
              color: BColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomCachedNetworkImage(
              image: homeProvider.homeBannerList[index].imageUrl ?? '',
              fit: BoxFit.cover,
            ),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            clipBehavior: Clip.antiAlias,
            autoPlay: homeProvider.homeBannerList.length <= 1 ? false : true,
            autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        );
      }
    });
  }
}
