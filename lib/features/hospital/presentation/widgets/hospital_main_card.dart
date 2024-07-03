import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class HospitalMainCard extends StatelessWidget {
  const HospitalMainCard({
    super.key,
    required this.screenwidth,
    required this.index,
    this.onTap,
  });
  final int index;
  final void Function()? onTap;

  final double screenwidth;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      final hospitals = hospitalProvider.hospitalList[index];
      return GestureDetector(
        onTap: hospitals.ishospitalON == false
            ? () {
                CustomToast.errorToast(
                    text: 'This Hospital is not available now!');
              }
            : onTap,
        child: Stack(
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: screenwidth,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: BColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      width: screenwidth,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16))),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Positioned.fill(
                              child: CustomCachedNetworkImage(
                                  image: hospitals.image!)),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  BColors.black.withOpacity(0.5),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  hospitals.hospitalName!.toUpperCase(),
                                  style: const TextStyle(
                                      color: BColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5),
                              //       color: BColors.buttonGreen),
                              //   child: const Padding(
                              //     padding: EdgeInsets.all(3),
                              //     child: Row(
                              //       children: [
                              //         Text(
                              //           '4.54',
                              //           style: TextStyle(
                              //               fontSize: 12,
                              //               fontWeight: FontWeight.w500),
                              //         ),
                              //         Icon(
                              //           Icons.star,
                              //           size: 14,
                              //           color: BColors.black,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              //),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              const Gap(3),
                              Expanded(
                                child: Text(
                                  '${hospitals.address}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (hospitals.ishospitalON == false)
                         Container(
                height: 160,
                width: screenwidth,
                decoration: BoxDecoration(
                    color: BColors.white.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16))),
                    child:Center(
                      child: Image.asset(BImage.healthyCartLogoWithOpacity, scale: 3,),
                    ) ,    
            ),
             if (hospitals.ishospitalON == false)
            Positioned(
              bottom: 40,
              right: 8,
              child:  Image.asset(
                  BImage.currentlyUnavailable,
                  scale: 5,
                )),
          ],
        ),
      );
    });
  }
}
