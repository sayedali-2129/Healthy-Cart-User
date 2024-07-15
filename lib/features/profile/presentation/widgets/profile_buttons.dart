import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });
  final String buttonName;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 56,
          width: double.infinity,
          color: BColors.profileButtonGrey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  buttonName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 22,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
