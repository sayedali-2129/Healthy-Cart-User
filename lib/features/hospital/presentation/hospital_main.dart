import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';

class HospitalMain extends StatefulWidget {
  const HospitalMain({super.key});

  @override
  State<HospitalMain> createState() => _HospitalMainState();
}

class _HospitalMainState extends State<HospitalMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        HomeSliverAppbar(searchHint: 'Search Hospitals'),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => Gap(5),
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              height: 257,
            ),
          ),
        )
      ],
    ));
  }
}
