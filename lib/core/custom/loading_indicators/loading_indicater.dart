import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicater extends StatelessWidget {
  const LoadingIndicater({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 100,
        child: Lottie.asset(BLottie.circularLoadingLottie));
  }
}
