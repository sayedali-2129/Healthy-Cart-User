import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_products.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/list_card_pharmacy.dart';
import 'package:page_transition/page_transition.dart';

class PharmacyMain extends StatefulWidget {
  const PharmacyMain({super.key});

  @override
  State<PharmacyMain> createState() => _PharmacyMainState();
}

class _PharmacyMainState extends State<PharmacyMain> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('pharmacysearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        HomeSliverAppbar(
          searchHint: 'Search Pharmacy',
          searchController: TextEditingController(),
          onChanged: (_) {
            EasyDebounce.debounce(
              'pharmacysearch',
              const Duration(milliseconds: 500),
              () {},
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          sliver: SliverList.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return PharmacyListCard(
                index: index,
                onTap: () {
                  EasyNavigation.push(
                    type: PageTransitionType.rightToLeft,
                      context: context, page: PharmacyProductScreen());
                },
              );
            },
          ),
        )
      ],
    );
  }
}
