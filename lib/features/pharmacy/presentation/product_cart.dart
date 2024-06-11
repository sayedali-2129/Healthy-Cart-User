import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/product_cart_list_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/summary_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ProductCartScreen extends StatelessWidget {
  const ProductCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
              title: 'Cart',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              }),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                "Orders",
                style: TextStyle(
                    fontSize: 16,
                    
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: 8,
              itemBuilder: (context, index) {
                return FadeInRight(
                  child: ProductListWidget(
                    index: index,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
            child:OrderPharmacySummaryCard(totalTestFee: 200, discount: 200, totalAmount: 2000) ,),
          )

        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 72,
        decoration: const BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8, right: 24),
          child: Align(
            alignment: Alignment.centerRight,
            child: ButtonWidget(
              onPressed: () {},
              buttonHeight: 48,
              buttonWidth: 160,
              buttonColor: BColors.darkblue,
              buttonWidget: const Text(
                'Check Out',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: BColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
