import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/home/application/provider/home_provider.dart';
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
        return const Gap(5);
      } else {
        return CarouselSlider.builder(
          itemCount: homeProvider.homeBannerList.length,
          itemBuilder: (context, index, realIndex) => Material(
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: widget.screenWidth,
              height: 202,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomCachedNetworkImage(
                  image: homeProvider.homeBannerList[index].imageUrl!),
            ),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: homeProvider.homeBannerList.length <= 1 ? false : true,
            autoPlayCurve: Curves.decelerate,
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
