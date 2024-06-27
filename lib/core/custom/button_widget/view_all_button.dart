import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ViewAllButton extends StatelessWidget {
  const ViewAllButton({
    super.key,
    required this.onTap,
  });
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        color: BColors.white,
        surfaceTintColor: BColors.white,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'View All',
            style: TextStyle(
                decorationColor: BColors.darkblue,
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BColors.darkblue),
          ),
        ),
      ),
    );
  }
}