import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class PatientDetailsContainer extends StatelessWidget {
  const PatientDetailsContainer({
    super.key,
    required this.patientName,
    required this.patientGender,
    required this.patientNumber,
    required this.patientAge,
    required this.patientPlace,
    this.onCall,
  });
  final String patientName;
  final String patientGender;
  final String patientNumber;
  final String patientAge;
  final String patientPlace;
  final void Function()? onCall;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Details',
              style: TextStyle(
                  fontSize: 12,
                  color: BColors.black,
                  decoration: TextDecoration.underline),
            ),
            Text(
              patientName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RowTwoTextWidget(
                          text1: 'Age', text2: patientAge, gap: 48),
                     const Gap(4),
                      RowTwoTextWidget(
                          text1: 'Place', text2: patientPlace, gap: 38),
                     const Gap(4),
                      RowTwoTextWidget(
                          text1: 'Gender', text2: patientGender, gap: 26),
                     const Gap(4),
                      RowTwoTextWidget(
                          text1: 'Phone No', text2: patientNumber, gap: 11),
                    ],
                  ),
                ),
                const Gap(12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RowTwoTextWidget extends StatelessWidget {
  const RowTwoTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.gap,
  });
  final String text1;
  final String text2;
  final double gap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12),
        ),
        Gap(gap),
        Text(
          text2,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              color: BColors.black, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
