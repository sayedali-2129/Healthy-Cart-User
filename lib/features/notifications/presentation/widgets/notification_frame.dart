import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/notifications/domain/models/notification_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:intl/intl.dart';

class NotificationFrame extends StatelessWidget {
  final NotificationModel notification;
  const NotificationFrame({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationDate = notification.isCreated!.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String formattedDate;

    if (notificationDate.year == today.year &&
        notificationDate.month == today.month &&
        notificationDate.day == today.day) {
      formattedDate = "Today";
    } else if (notificationDate.year == yesterday.year &&
        notificationDate.month == yesterday.month &&
        notificationDate.day == yesterday.day) {
      formattedDate = "Yesterday";
    } else {
      formattedDate = DateFormat.yMd().format(notificationDate);
    }

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(16),
      surfaceTintColor: BColors.white,
      child: Container(
        decoration: BoxDecoration(
            color: BColors.white, borderRadius: BorderRadius.circular(16)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      // clipBehavior: Clip.antiAlias,
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        BImage.roundedSplashLogo,
                      )),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          notification.title ?? '',
                          style: const TextStyle(
                              color: BColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          notification.description ?? '',
                          style: const TextStyle(
                              color: BColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45),
                      )
                    ],
                  ),
                ],
              ),
              const Gap(5),
              notification.imageUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          height: notification.imageUrl == null ? 0 : 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomCachedNetworkImage(
                              image: notification.imageUrl!)),
                    )
                  : const Gap(0)
            ],
          ),
        ),
      ),
    );
  }
}
