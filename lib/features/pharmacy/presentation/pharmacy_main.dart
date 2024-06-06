import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';

class PharmacyMain extends StatelessWidget {
  const PharmacyMain({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        HomeSliverAppbar(searchHint: 'Search Pharmacy', searchController: TextEditingController(), onChanged: (_){},)
        
      ],
    );
  }
}
