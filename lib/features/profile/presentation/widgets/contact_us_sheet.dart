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
      width: screenWidth,
      decoration: const BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                LaunchDialer.lauchDialer(phoneNumber: AppDetails.phoneNumber);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: BColors.darkblue,
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: BColors.white,
                      ),
                      Gap(12),
                      Text(
                        'Give Us a Call',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: BColors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Gap(12),
            GestureDetector(
              onTap: () {
                UrlService().redirectToWhatsapp(
                  whatsAppLink:
                      "https://wa.me/${AppDetails.phoneNumber}?text=Hi there! 👋 I'm looking for assistance with my query. Could you please help me? Thank you!",
                  onFailure: () {
                    CustomToast.sucessToast(
                        text: "Chat option is not currently available");
                  },
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: BColors.darkblue,
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: BColors.white,
                      ),
                      Gap(12),
                      Text(
                        'Chat With Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: BColors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Gap(12),
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
                height: 48,
                decoration: BoxDecoration(
                    color: BColors.darkblue,
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: BColors.white,
                      ),
                      Gap(12),
                      Text(
                        'Send Us an Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: BColors.white,
                        ),
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
