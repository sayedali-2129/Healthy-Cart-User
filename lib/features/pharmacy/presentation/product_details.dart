import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/ad_pharmacy_slider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/details_widgets.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productData});
final PharmacyProductAddModel productData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
              title: 'Product Info',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              }),
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 200,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 32),
                child: Container(
                  color: BColors.lightGrey,
                  child: const AdPharmacySlider(
                    pharmacyId: '',
                    screenWidth: double.infinity,
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: BColors.lightGrey.withOpacity(.5),
                  surfaceTintColor: BColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 24,
                  ),
                )),
          ),
          SliverToBoxAdapter(
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: BColors.lightGrey.withOpacity(.5),
              surfaceTintColor: BColors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gelusil MPS Antacid & Antigas Original Liquid 500ml',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                          color: BColors.textBlack),
                    ),
                    const Gap(4),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'by  ', // remeber to put space
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: BColors.textLightBlack),
                          ),
                          TextSpan(
                            text: 'Cipla Pvt LTD',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: BColors.textLightBlack),
                          ),
                        ])),
                    const Gap(12),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: RichText(
                              maxLines: 2,
                              text: TextSpan(children: [
                                const TextSpan(
                                  text: 'Our price : ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
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
                                  text: "${2000}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: BColors.green),
                                ),
                                const TextSpan(text: '  '),
                                const TextSpan(
                                  text: "3000",
                                  style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: BColors.textBlack),
                                ),
                              ])),
                        ),
                        const Gap(16),
                        Flexible(
                            child: PercentageShowContainerWidget(
                                width: 56,
                                height: 32,
                                text: '41 %',
                                textColor: BColors.white,
                                boxColor: BColors.offRed)),
                      ],
                    ),
                    const Gap(16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProductInfoWidget(
                          text1: 'Product Form :',
                          text2: '30 - Capsule',
                        ),
                        ProductInfoWidget(
                          text1: 'Product Package :',
                          text2: 'Bottle',
                        ),
                      ],
                    ),
                    const Gap(8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProductInfoWidget(
                          text1: 'Ideal For :',
                          text2: 'Everyone',
                        ),
                        ProductInfoWidget(
                          text1: 'Measurement :',
                          text2: '50 - mg',
                        ),
                      ],
                    ),
                    const Gap(8),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                color: BColors.lightGrey.withOpacity(.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: const TextSpan(children: [
                        TextSpan(
                          text: 'Key Ingredients : ', // remeber to put space
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: BColors.textLightBlack),
                        ),
                        TextSpan(
                          text: 'Calcium, Magnesium, Pottassium',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack),
                        ),
                      ])),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                color: BColors.white,
                child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductDetailsHeading(text: 'Product Information : '),
                        Gap(4),
                        Text(
                          'Aluminium hydroxide is an antacid, which neutralises increased stomach acid.Dimethicone is an antiflatulent which helps in releasing the gas.Magnesium hydroxide is a laxative that increases water in the intestine and reduces stomach acid.',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BColors.textBlack),
                        )
                      ],
                    )),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                color: BColors.lightGrey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Image.asset(
                          BIcon.rxIcon,
                          height: 24,
                        )),
                        Gap(16),
                        Flexible(
                          flex: 2,
                          child: Text(
                            'This item requires a prescription.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: BColors.textBlack),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                color: BColors.lightGrey.withOpacity(.5),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ProductInfoWidget(
                        text1: 'Expiry Date :',
                        text2: '06-2025',
                      ),
                      ProductInfoWidget(
                        text1: 'Product type :',
                        text2: 'Diabetes Monitoring',
                      ),
                      ProductInfoWidget(
                        text1: 'Store Below :',
                        text2: '30 C',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                color: BColors.white,
                child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductDetailsHeading(text: 'Direction To Use : '),
                        Gap(4),
                        Text(
                          'Aluminium hydroxide is an antacid, which neutralises increased stomach acid.Dimethicone is an antiflatulent which helps in releasing the gas.Magnesium hydroxide is a laxative that increases water in the intestine and reduces stomach acid.',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BColors.textBlack),
                        ),
                        Gap(8),
                        ProductDetailsHeading(text: 'Safety Information : '),
                        Gap(4),
                        Text(
                          'Aluminium hydroxide is an antacid, which neutralises increased stomach acid.Dimethicone is an antiflatulent which helps in releasing the gas.Magnesium hydroxide is a laxative that increases water in the intestine and reduces stomach acid.',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BColors.textBlack),
                        ),
                        Gap(80)
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8, right: 24),
          child: Align(
            alignment: Alignment.centerRight,
            child: ButtonWidget(
              buttonHeight: 48,
              buttonWidth: 160,
              buttonColor: BColors.offRed,
              buttonWidget: Text(
                'Add to Cart',
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
