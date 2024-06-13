import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.screenWidth,
    this.onTapTab1,
    this.onTapTab2,
    required this.tab1Color,
    required this.tab2Color,
    required this.text1,
    required this.text2,
  });

  final double screenWidth;
  final void Function()? onTapTab1;
  final void Function()? onTapTab2;
  final Color tab1Color;
  final Color tab2Color;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTapTab1,
            child: Container(
              width: screenWidth / 2,
              height: 40,
              decoration: BoxDecoration(
                  color: tab1Color,
                  border: Border.all(width: 0.5),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(8))),
              child: Center(
                child: Text(
                  text1,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTapTab2,
            child: Container(
              width: screenWidth / 2,
              height: 40,
              decoration: BoxDecoration(
                  color: tab2Color,
                  border: Border.all(width: 0.5),
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(8))),
              child: Center(
                child: Text(
                  text2,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
