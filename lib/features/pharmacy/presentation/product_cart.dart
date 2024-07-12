import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_checkout.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/product_cart_list_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/type_of_service_radio.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
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
        pharmacyProvider.getpharmcyCartProduct().whenComplete(
          () {
            pharmacyProvider.totalAmountCalclator();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverCustomAppbar(
                title: 'Cart',
                onBackTap: () {
                  Navigator.pop(context);
                },
              ),
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
              if (pharmacyProvider.selectedpharmacyData?.isHomeDelivery ==
                  false)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: BColors.offRed,
                          size: 32,
                        ),
                        const Gap(8),
                        const Expanded(
                          child: Text(
                            "At this time, our pharmacy only offers order Pick-Up and does not provide Home Delivery services.",
                            style: TextStyle(
                                fontSize: 12,
                                color: BColors.textLightBlack,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ],
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
                          return FadeInUp(
                            duration: const Duration(milliseconds: 500),
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
                  text: 'No items added to your cart!',
                ),
            ],
          ),
          bottomNavigationBar: (pharmacyProvider
                  .pharmacyCartProducts.isNotEmpty)
              ? FadeInUp(
                  child: Container(
                    width: double.infinity,
                    height: 72,
                    decoration: const BoxDecoration(
                        color: BColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16, top: 8, right: 24, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total to be paid :',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: BColors.textLightBlack,
                                  ),
                                ),
                                const Gap(2),
                                (pharmacyProvider.totalFinalAmount ==
                                        pharmacyProvider.totalAmount)
                                    ? RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text: 'Our price : ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Montserrat',
                                                color: BColors.textBlack),
                                          ),
                                          TextSpan(
                                            text: "₹ ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                color: BColors.green),
                                          ),
                                          TextSpan(
                                            text:
                                                '${pharmacyProvider.totalAmount}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                color: BColors.green),
                                          ),
                                        ]),
                                      )
                                    : RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "₹ ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Montserrat',
                                                  color: BColors.green)),
                                          TextSpan(
                                            text:
                                                "${pharmacyProvider.totalFinalAmount}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                color: BColors.green),
                                          ),
                                          const TextSpan(text: '  '),
                                          const TextSpan(
                                              text: "₹ ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontFamily: 'Montserrat',
                                                  color: BColors.textBlack)),
                                          TextSpan(
                                            text:
                                                "${pharmacyProvider.totalAmount}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontFamily: 'Montserrat',
                                                color: BColors.textBlack),
                                          ),
                                        ]),
                                      ),
                              ],
                            ),
                          ),
                          ButtonWidget(
                            onPressed: () {
                              if (pharmacyProvider
                                  .cartContainsOutOfStockProduct()) {
                                CustomToast.errorToast(
                                    text:
                                        'Cart contains item out of stock, please remove the item.');
                                return;
                              }
                              if (pharmacyProvider
                                      .selectedpharmacyData?.isHomeDelivery ==
                                  false) {
                                pharmacyProvider.selectedRadio =
                                    pharmacyProvider.pharmacyPickup;
                                EasyNavigation.push(
                                  type: PageTransitionType.rightToLeft,
                                  context: context,
                                  page: const PharmacyCheckOutScreen(),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeliveryTypeRadiopopup(
                                      onConfirm: () {
                                        if (pharmacyProvider.selectedRadio ==
                                            null) {
                                          CustomToast.errorToast(
                                              text:
                                                  'Select a delivery type to check out.');
                                          return;
                                        }
                                        EasyNavigation.pop(context: context);

                                        EasyNavigation.push(
                                          type: PageTransitionType.rightToLeft,
                                          context: context,
                                          page: const PharmacyCheckOutScreen(),
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            },
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
                        ],
                      ),
                    ),
                  ),
                )
              : null);
    });
  }
}
