import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineOrderStatus extends StatelessWidget {
  const TimeLineOrderStatus(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.icon,
      required this.text, required this.height, required this.widthOfLine});
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final IconData icon;
  final String text;
  final double height;
  final double widthOfLine;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthOfLine,
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? BColors.green : BColors.offRed.withOpacity(.6),
        ),
        indicatorStyle: IndicatorStyle(
            color: isPast ? BColors.green : BColors.offRed.withOpacity(.7),
            width: height,
            height: height,
            iconStyle: IconStyle(
                iconData: icon,
                fontSize: 24,
                color:
                    isPast ? BColors.white : BColors.white.withOpacity(0.6))),
        endChild: Text(
          text,
          style: const TextStyle(
              fontSize: 12,
              color: BColors.textBlack,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat'),
        ),
      ),
    );
  }
}
