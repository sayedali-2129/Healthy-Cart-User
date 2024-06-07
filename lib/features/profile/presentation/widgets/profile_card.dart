import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.userIamge,
    this.userName,
    this.userLocation,
  });
  final String? userIamge;
  final String? userName;
  final String? userLocation;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      child: SizedBox(
        child: Row(
          children: [
            Container(
                clipBehavior: Clip.antiAlias,
                height: 70,
                width: 70,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: userIamge == null
                    ? Image.asset(
                        BImage.userAvatar,
                        fit: BoxFit.cover,
                      )
                    : CustomCachedNetworkImage(image: userIamge!)),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? 'User',
                  style: TextStyle(
                      fontSize: 18,
                      color: BColors.black,
                      fontWeight: FontWeight.w700),
                ),
                Text(userLocation ?? '',
                    style: TextStyle(
                        fontSize: 14,
                        color: BColors.black,
                        fontWeight: FontWeight.w500))
              ],
            )
          ],
        ),
      ),
    );
  }
}
