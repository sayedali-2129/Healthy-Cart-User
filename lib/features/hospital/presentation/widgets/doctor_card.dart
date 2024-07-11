import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, required this.fromHomePage});
  final DoctorModel doctor;
  final bool fromHomePage;
  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        surfaceTintColor: BColors.white,
        shadowColor: BColors.black.withOpacity(0.8),
        child: Container(
          // height: 110,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: BColors.lightGrey,
              blurRadius: 2.0,
            ),
          ], borderRadius: BorderRadius.circular(12), color: BColors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:
                      CustomCachedNetworkImage(image: doctor.doctorImage ?? ''),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///////////////DOCTOR NAME///////////////
                      Text(
                        '${doctor.doctorName} (${doctor.doctorQualification})',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: BColors.black),
                      ),
                      const Gap(4),
                      ///////////////CATEGORY//////////////////
                      Text(
                       (fromHomePage)? doctor.hospital ?? 'Unknown Hospital': doctor.doctorSpecialization ?? "",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: BColors.textLightBlack),
                      ),
                      const Gap(4),
                      Text(
                        'Time : ${doctor.doctorTotalTime ?? ""}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: BColors.green),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
