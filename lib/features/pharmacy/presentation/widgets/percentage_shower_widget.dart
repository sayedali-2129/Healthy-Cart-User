import 'package:flutter/material.dart';

class PercentageShowContainerWidget extends StatelessWidget {
  const PercentageShowContainerWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.boxColor,
    this.width,
    this.height,
  });
  final String text;
  final Color textColor;
  final Color boxColor;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          color: boxColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
          ),
        ),
      ),
    );
  }
}
