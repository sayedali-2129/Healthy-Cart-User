
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {super.key,
      this.width,
      this.height,
      this.radius = 14,
      this.child,
      this.showBorder = false,
      this.borderColor = BColors.black,
      this.backgroundColor = BColors.white,
      this.padding,
      this.margin});

  final double? width;
  final double? height;
  final double radius;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}

class RoundedImage extends StatelessWidget {
  const RoundedImage(
      {super.key,
      required this.child,
      this.width = 150,
      this.height = 150,
      this.applyBorderRadius = false,
      this.border,
      this.backgroundColor = BColors.grey,
      this.padding,
  
      this.borderRadius = 12});

  final Widget child;
  final double? width;
  final double? height;
  final bool applyBorderRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: ClipRRect(
          borderRadius: applyBorderRadius
              ? BorderRadius.circular(10)
              : BorderRadius.zero,
          child: child
          ),
    );
  }
}
