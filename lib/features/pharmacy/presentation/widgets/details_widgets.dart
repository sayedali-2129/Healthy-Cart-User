import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ProductDetailsHeading extends StatelessWidget {
  const ProductDetailsHeading({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
          color: BColors.textBlack),
    );
  }
}

class ProductInfoWidget extends StatelessWidget {
  const ProductInfoWidget({
    super.key,
    this.fontSize2 = 13,
    this.fontSize1 = 12,
    required this.text1,
    required this.text2,
  });
  final String text1;
  final String text2;
 final double? fontSize1;
 final double? fontSize2;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:  TextStyle(
              fontSize: fontSize1,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: BColors.textLightBlack),
        ),
        const Gap(2),
        Text(
          text2,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:  TextStyle(
              fontSize: fontSize2,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: BColors.textBlack),
        ),
      ],
    );
  }
}

class ProductDetailsStraightWidget extends StatelessWidget {
  const ProductDetailsStraightWidget({
    super.key,
    required this.title,
    required this.text,
  });
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 6,
        text: TextSpan(children: [
          TextSpan(
            text: title, // remeber to put space
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BColors.textLightBlack),
          ),
          TextSpan(
            text: text,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: BColors.textBlack),
          ),
        ]));
  }
}
