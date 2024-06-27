import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class PharmacyListCard extends StatelessWidget {
  const PharmacyListCard({
    super.key,
    required this.screenwidth,
    this.onTap,
    required this.pharmacy,
  });

  final void Function()? onTap;

  final double screenwidth;
  final PharmacyModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pharmacy.isPharmacyON == false
          ? () {
              CustomToast.errorToast(
                  text: 'This Pharmacy is not available now!');
            }
          : onTap,
      child: Stack(
        children: [
          Container(
            width: screenwidth,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: BColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: BColors.black.withOpacity(0.1),
                    blurRadius: 7,
                    spreadRadius: 5),
              ],
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,                  width: screenwidth,
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
                              image: pharmacy.pharmacyImage!)),
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
                              pharmacy.pharmacyName!.toUpperCase(),
                              style: const TextStyle(
                                  color: BColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: BColors.buttonGreen),
                            child: const Padding(
                              padding: EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  Text(
                                    '4.54',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: BColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                              '${pharmacy.pharmacyAddress}',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
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
          if (pharmacy.isPharmacyON == false)
            Container(
                height: 200,
                width: screenwidth,
                decoration: BoxDecoration(
                    color: BColors.white.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16))),
                child: Image.asset(
                  BImage.currentlyUnavailable,
                  scale: 3,
                )),
        ],
      ),
    );
  }
}
