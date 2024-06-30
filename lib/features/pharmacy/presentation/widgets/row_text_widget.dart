import 'package:flutter/material.dart';

class RowTextContainerWidget extends StatelessWidget {
  const RowTextContainerWidget({
    super.key,
    required this.text1,
    required this.text2,
    this.fontSizeText1 = 13,
    this.fontSizeText2,
    this.text2Color,
    this.text1Color,
    this.fontWeightText1 = FontWeight.w500,
    this.fontWeightText2 = FontWeight.w600,
  });
  final String text1;
  final String text2;
  final double? fontSizeText1;
  final double? fontSizeText2;
  final Color? text2Color;
  final Color? text1Color;
  final FontWeight? fontWeightText1;
  final FontWeight? fontWeightText2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: fontSizeText1,
              fontWeight: fontWeightText1,
              color: text1Color),
        ),
        Text(
          text2,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: fontSizeText2,
              fontWeight: fontWeightText2,
              color: text2Color),
        ),
      ],
    );
  }
}
