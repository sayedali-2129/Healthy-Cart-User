import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class PharmacyHorizontalCard extends StatelessWidget {
  const PharmacyHorizontalCard({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      final pharmacy = pharmacyProvider.pharmacyList[index];
      return Center(
        child: Material(
          borderRadius: BorderRadius.circular(8),
          elevation: 5,
          child: Container(
            height: 215,
            width: 225,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: BColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),
                        child: CustomCachedNetworkImage(
                            fit: BoxFit.cover, image: pharmacy.pharmacyImage!),
                      ),
                      if (pharmacy.isPharmacyON == false)
                        Container(
                            height: 130,
                            decoration: BoxDecoration(
                                color: BColors.white.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8))),
                            child: Image.asset(
                              BImage.currentlyUnavailable,
                              scale: 5,
                            )),
                    ],
                  ),
                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pharmacy.pharmacyName!.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: BColors.black,
                              fontSize: 12,
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
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                              Icon(
                                Icons.star,
                                size: 12,
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
                        size: 15,
                      ),
                      const Gap(3),
                      Expanded(
                        child: Text(
                          pharmacy.pharmacyAddress ?? 'No Address',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
