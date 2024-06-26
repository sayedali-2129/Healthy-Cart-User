import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:provider/provider.dart';

class AdSlider extends StatefulWidget {
  const AdSlider({
    super.key,
    required this.screenWidth,
    required this.labId,
  });

  final double screenWidth;
  final String labId;

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      if (labProvider.labBannerList.isEmpty) {
        return const Gap(5);
      } else {
        return CarouselSlider.builder(
          itemCount: labProvider.labBannerList.length,
          itemBuilder: (context, index, realIndex) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: widget.screenWidth,
              height: 202,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomCachedNetworkImage(
                  image: labProvider.labBannerList[index].image!),
            ),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: labProvider.labBannerList.length <= 1 ? false : true,
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
