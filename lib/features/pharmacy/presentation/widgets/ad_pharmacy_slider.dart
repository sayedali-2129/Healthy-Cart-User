import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class AdPharmacySlider extends StatefulWidget {
  const AdPharmacySlider({
    super.key,
    required this.screenWidth,
    required this.labId,
  });

  final double screenWidth;
  final String labId;

  @override
  State<AdPharmacySlider> createState() => _AdPharmacySliderState();
}

class _AdPharmacySliderState extends State<AdPharmacySlider> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3,
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
              image: BImage.healthycartText),
        ),
      ),
      options: CarouselOptions(
        viewportFraction: 1,
        initialPage: 0,
        // autoPlay: labProvider.labBannerList.length <= 1 ? false : true,
        autoPlayCurve: Curves.decelerate,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
