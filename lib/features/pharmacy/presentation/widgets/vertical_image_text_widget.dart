import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.onTap,

  });
  final String title;
  final void Function()? onTap;
  final String image;
  @override
  Widget build(BuildContext context) { 
        return GestureDetector(
         onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: CustomCachedNetworkImage(
                    image: image,
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: 88,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style:const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: BColors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
  }
}
