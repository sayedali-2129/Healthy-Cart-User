import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicater extends StatelessWidget {
  const LoadingIndicater({
    super.key, this.height = 100, this.width = 100,
  });
  final double? height;
   final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: Lottie.asset(BLottie.circularLoadingLottie));
  }
}
