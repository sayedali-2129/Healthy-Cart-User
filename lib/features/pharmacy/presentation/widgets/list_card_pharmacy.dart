import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class PharmacyListCard extends StatelessWidget {
  const PharmacyListCard({
    super.key,
    this.onTap,
    required this.pharmacy,
  });
  final void Function()? onTap;
  final PharmacyModel pharmacy;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (pharmacy.isPharmacyON == false)
          ? () {
              CustomToast.sucessToast(
                  text: 'This Pharmacy is not available right now!');
            }
          : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Stack(
          children: [
            Container(
              height: 104,
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                    color: BColors.black.withOpacity(0.3))
              ], border: Border.all(), borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 52,
                          width: 52,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: CustomCachedNetworkImage(
                              image: pharmacy.pharmacyImage ?? ''),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pharmacy.pharmacyName ??
                                    'Unknown Pharmacy Name',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.black),
                              ),
                              const Gap(5),
                              Text(
                                pharmacy.pharmacyAddress ?? 'Unknown Address',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),
                  ],
                ),
              ),
            ),
            if (pharmacy.isPharmacyON == false)
              Container(
                height: 104,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: BColors.white.withOpacity(0.7),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(16)),
                child: const Center(
                    // child: Text(
                    //   'This Laboratory is not available right now!',
                    //   style: TextStyle(
                    //       color: BColors.black, fontWeight: FontWeight.w600),
                    // ),
                    ),
              )
          ],
        ),
      ),
    );
  }
}
