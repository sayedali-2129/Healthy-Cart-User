import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        surfaceTintColor: BColors.white,
        shadowColor: BColors.black.withOpacity(0.8),
        child: Container(
          // height: 110,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: BColors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: 67,
                  width: 67,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomCachedNetworkImage(
                      image: hospitalProvider.doctorsList[index].doctorImage!),
                ),
                const Gap(16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///////////////DOCTOR NAME///////////////
                    Text(
                      '${hospitalProvider.doctorsList[index].doctorName} (${hospitalProvider.doctorsList[index].doctorQualification})',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BColors.black),
                    ),
                    const Gap(4),
                    ///////////////CATEGORY//////////////////
                    Text(
                      hospitalProvider
                              .doctorsList[index].doctorSpecialization ??
                          "",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: BColors.black),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
