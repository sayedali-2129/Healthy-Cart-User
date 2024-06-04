import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';

class AdSlider extends StatefulWidget {
  const AdSlider({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  State<AdSlider> createState() => _AdSliderState();
}

class _AdSliderState extends State<AdSlider> {
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Provider.of<BannerController>(context, listen: false).fetchBanner();
  //   });

  //   super.initState();
  // }
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 1,
          itemBuilder: (context, index, realIndex) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child:
                //  provider.banners.isEmpty ?
                // Center(
                //     child: LottieBuilder.asset(
                //     ConstantIcons.lottieProgress,
                //     height: 100,
                //     width: 100,
                //   )) :
                Container(
              clipBehavior: Clip.antiAlias,
              width: widget.screenWidth,
              height: 202,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomCachedNetworkImage(
                  image:
                      'https://thumbs.dreamstime.com/b/lab-assistant-studying-samples-to-detect-pathologies-quality-medical-research-stock-video-105848572.jpg'),
            ),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: true,
            //  autoPlay: addBannerProvider.bannerList.length <= 1 ? false : true,
            autoPlayCurve: Curves.decelerate,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        // DotsIndicator(
        //   dotsCount: provider.banners.length,
        //   position: currentIndex,
        // )
      ],
    );
  }
}

// Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           height: 202,
//           width: screenWidth,
//           decoration: const BoxDecoration(
//             color: Colors.amber,
//             borderRadius: BorderRadius.all(Radius.circular(16)),
//           ),
//         ),
//         Center(
//           child: SvgPicture.asset(
//             ConstantImage.adBannerSampleSvg,
//             width: screenWidth,
//             // height: 202,
//           ),
//         ),
//       ],
//     );
