import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class SliverCustomAppbar extends StatelessWidget {
  const SliverCustomAppbar({
    super.key,
    required this.title,
    required this.onBackTap,
    this.child,
  });
  final String title;

  final VoidCallback onBackTap;
  final PreferredSizeWidget? child;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: BColors.mainlightColor,
        titleSpacing: -6,
        pinned: true,
        floating: true,
        forceElevated: true,
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        leading: IconButton(
            onPressed: onBackTap,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: BColors.darkblue,
            )),
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: BColors.darkblue)),
        bottom: child);
  }
}
