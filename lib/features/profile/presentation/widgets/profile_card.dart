import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.userImage,
    this.userName,
    this.userLocation,
    this.localArea,
    this.district,
  });
  final String? userImage;
  final String? userName;
  final String? userLocation;
  final String? localArea;
  final String? district;
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
                child: userImage == null
                    ? Image.asset(
                        BImage.userAvatar,
                        fit: BoxFit.cover,
                      )
                    : CustomCachedNetworkImage(image: userImage!)),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? 'User',
                  style: const TextStyle(
                      fontSize: 18,
                      color: BColors.black,
                      fontWeight: FontWeight.w700),
                ),
                localArea == null && district == null
                    ? const Gap(0)
                    : Text(userLocation!,
                        style: const TextStyle(
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
