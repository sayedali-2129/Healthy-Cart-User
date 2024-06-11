import 'package:flutter/material.dart';


class ProductImageShowerWidget extends StatelessWidget {
  const ProductImageShowerWidget({
    super.key,
    required this.addTap,
    required this.child,
    required this.height,
    required this.width, 
  });
  final VoidCallback addTap;
  final Widget child;
  final double height;
  final double width;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: addTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle
        ),
        child: child
    ));
  }
}
