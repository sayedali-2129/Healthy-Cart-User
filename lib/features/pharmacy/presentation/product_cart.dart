import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/product_cart_list_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class ProductCartScreen extends StatefulWidget {
  const ProductCartScreen({super.key});

  @override
  State<ProductCartScreen> createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final pharmacyProvider =
            Provider.of<PharmacyProvider>(context, listen: false);
        pharmacyProvider.getpharmcyCartProduct();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
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
            (pharmacyProvider.fetchLoading == true &&
                    pharmacyProvider.pharmacyCartProducts.isEmpty)
                ? const SliverFillRemaining(
                    child: Center(
                      child: LoadingIndicater(),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList.builder(
                      itemCount: pharmacyProvider.pharmacyCartProducts.length,
                      itemBuilder: (context, index) {
                        return FadeInRight(
                          child: ProductListWidget(
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
            if (pharmacyProvider.fetchLoading == false &&
                pharmacyProvider.pharmacyCartProducts.isEmpty)
              const ErrorOrNoDataPage(
                text: 'No product added to cart.',
              ),
          ],
        ),
        bottomSheet: (pharmacyProvider.pharmacyCartProducts.isNotEmpty)
            ? Container(
                width: double.infinity,
                height: 72,
                decoration: const BoxDecoration(
                    color: BColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
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
              )
            : null);
  }
}
