import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/launch_dialer.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/url_launcher.dart';
import 'package:healthy_cart_user/utils/app_details.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ContactUsBottomSheet extends StatelessWidget {
  const ContactUsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                LaunchDialer.lauchDialer(phoneNumber: AppDetails.phoneNumber);
              },
              child: Container(
                height: 55,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: BColors.lightGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone),
                      Gap(10),
                      Text(
                        'Call',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Gap(10),
            GestureDetector(
              onTap: () {
                UrlService().redirectToLink(
                  link: 'mailto:<${AppDetails.email}>?subject=&body=',
                  onFailure: () async {
                    await Clipboard.setData(
                        const ClipboardData(text: AppDetails.email));
                    CustomToast.sucessToast(text: "Email Copied");
                  },
                );
              },
              child: Container(
                height: 55,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: BColors.lightGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email_outlined),
                      Gap(10),
                      Text(
                        'Mail',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
