import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
    required this.text,
    required this.buttonColor,
    required this.style,
    this.icon, this.iconColor, this.iconSize,
  });
  final String text;
  final double width;
  final double height;
  final VoidCallback onTap;
  final Color buttonColor;
  final TextStyle style;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: buttonColor),
          child: (icon == null)
              ? Text(text, style: style)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(text, style: style),
                    Icon(
                      icon,
                      color:iconColor ,
                      size: iconSize,
                    ),
                  ],
                )),
    );
  }
}
