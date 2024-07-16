import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class RowElevatedButton extends StatelessWidget {
  const RowElevatedButton({
    super.key,
    required this.text,
    required this.image,

    required this.buttonTap,
  });
  final String text;
  final String image;
  final VoidCallback buttonTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: BColors.lightgreen,
      surfaceTintColor: BColors.white,
      child: InkWell(
        onTap: buttonTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  height: 20,
                  width: 20,
                ),
                const Gap(4),
                Text(text,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: BColors.textLightBlack)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
