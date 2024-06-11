
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class QuantityCountWidget extends StatelessWidget {
  const QuantityCountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: BColors.white,
          surfaceTintColor: BColors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 3,
          child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(
                Icons.remove,
                size: 24,
                color: BColors.red,
              )),
        ),
        const Gap(8),
        Material(
          color: BColors.white,
          surfaceTintColor: BColors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 3,
          child:const SizedBox(
              height: 40,
              width: 40,
              child:Center(child:  Text('25', style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: BColors.darkblue),))
              ),
        ),
           const Gap(8),
        Material(
          color: BColors.white,
          surfaceTintColor: BColors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 3,
          child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(
                Icons.add,
                size: 24,
                color: BColors.red,
              )),
        )
      ],
    );
  }
}
