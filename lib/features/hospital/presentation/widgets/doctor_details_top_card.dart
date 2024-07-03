import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class DoctorDetailsTopCard extends StatelessWidget {
  const DoctorDetailsTopCard({
    super.key,
    required this.doctors,
    required this.isBooking,
  });

  final DoctorModel doctors;
  final bool isBooking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: 120,
              height: 120,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: CustomCachedNetworkImage(image: doctors.doctorImage?? ''),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctors.doctorName ?? 'Unknown Name',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: BColors.doctorTextGreen),
                    ),
                    const Gap(5),
                    Text(
                      doctors.doctorQualification?.toUpperCase() ??
                          '',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BColors.doctorTextGreen),
                    ),
                    const Gap(5),
                    Text(
                      doctors.doctorSpecialization ?? '',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BColors.doctorTextGreen),
                    ),
                    const Gap(5),
                    isBooking == true
                        ? Row(
                          children: [
                           const Text(
                                'Consulting Fee : ',
                                style:  TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.textBlack),
                              ),
                                Text(
                                '${doctors.doctorFee}',
                                style:  TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.green),
                              ),
                          ],
                        )
                        : Text(
                        (doctors.doctorExperience == 1)?
                            '${doctors.doctorExperience?.toString() ?? ''} Year Experience': '${doctors.doctorExperience?.toString() ?? ''} Years Experience' ,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: BColors.textLightBlack),
                          ),
                    // Gap(5),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.location_on,
                    //       size: 13,
                    //     ),
                    //     Gap(5),
                    //     Expanded(
                    //       child: Text(
                    //         hospitalAddress,
                    //         style: const TextStyle(
                    //             fontSize: 12,
                    //             fontWeight: FontWeight.w500,
                    //             color: BColors.textGrey),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
        isBooking == true
            ? const Gap(0)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(8),
                  const Text(
                    'About Doctor',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BColors.darkblue),
                  ),
                  const Gap(8),
                  Text(
                    doctors.doctorAbout ?? 'About',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: BColors.textLightBlack),
                  )
                ],
              )
      ],
    );
  }
}
