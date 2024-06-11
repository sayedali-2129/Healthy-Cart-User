import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';

class ProductCartScreen extends StatelessWidget {
  const ProductCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(title: 'Cart', 
          onBackTap: (){
            EasyNavigation.pop(context: context);
          })
          
        ],
      ),
    );
  }
}
