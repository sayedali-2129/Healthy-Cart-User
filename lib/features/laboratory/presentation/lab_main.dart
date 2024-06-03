import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_list_card.dart';

class LabMain extends StatelessWidget {
  const LabMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const HomeSliverAppbar(
          searchHint: 'Search Pharmacy',
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const Gap(8),
            itemCount: 5,
            itemBuilder: (context, index) => LabListCard(),
          ),
        )
      ],
    ));
  }
}
