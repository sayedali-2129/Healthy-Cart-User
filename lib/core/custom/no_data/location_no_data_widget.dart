import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class NoDataInSelectedLocation extends StatelessWidget {
  const NoDataInSelectedLocation({
    super.key, required this.locationTitle, required this.typeOfService,
  });
  
 final String locationTitle; 
 final String typeOfService;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: BColors.mainlightColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.report,
              color: BColors.offRed,
              size: 32,
            ),
            const Gap(8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text:"Oops! We're not in " ,
                        style:  TextStyle(
                          color: BColors.darkblue,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                        ),),
                    TextSpan(
                      text: locationTitle,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BColors.black),
                    ),
                       TextSpan(
                      text: " yet, but don't worry! Here are some great $typeOfService nearby that you can check out.",
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: BColors.darkblue),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}