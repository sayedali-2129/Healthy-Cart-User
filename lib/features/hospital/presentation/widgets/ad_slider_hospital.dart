import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:provider/provider.dart';

class AdSliderHospital extends StatefulWidget {
  const AdSliderHospital({
    super.key,
    required this.screenWidth,
    required this.labId,
  });

  final double screenWidth;
  final String labId;

  @override
  State<AdSliderHospital> createState() => _AdSliderHospitalState();
}

class _AdSliderHospitalState extends State<AdSliderHospital> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      if (hospitalProvider.hospitalBanner.isEmpty) {
        return const Gap(5);
      } else {
        return CarouselSlider.builder(
          itemCount: hospitalProvider.hospitalBanner.length,
          itemBuilder: (context, index, realIndex) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            clipBehavior: Clip.antiAlias,
            width: widget.screenWidth,
            height: 202,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomCachedNetworkImage(
                image: hospitalProvider.hospitalBanner[index].image!, fit: BoxFit.cover,),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            autoPlay:
                hospitalProvider.hospitalBanner.length <= 1 ? false : true,
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
