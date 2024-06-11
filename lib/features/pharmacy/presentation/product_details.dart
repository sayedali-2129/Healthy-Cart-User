import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/details_widgets.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/image_gallery_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_count_add.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productData});
  final PharmacyProductAddModel productData;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final pharmacyProvider =
        Provider.of<PharmacyProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        pharmacyProvider.bottomsheetSwitch(false);
      },
    );
  }

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
            backgroundColor: BColors.white,
            automaticallyImplyLeading: false,
            toolbarHeight: 300,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(
                    top: 24, right: 16, left: 16, bottom: 32),
                child: FadeInUp(
                  child: const GalleryImagePicker(),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: BColors.lightGrey.withOpacity(.5),
                surfaceTintColor: BColors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: const SizedBox(
                  width: double.infinity,
                  height: 24,
                ),
              ),
            ),
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
                    Text(
                      widget.productData.productName ?? 'Unknown Name',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                          color: BColors.textBlack),
                    ),
                    const Gap(4),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(children: [
                          const TextSpan(
                            text: 'by  ', // remeber to put space
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: BColors.textLightBlack),
                          ),
                          TextSpan(
                            text: widget.productData.productBrandName ??
                                'Unknown Brand',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: BColors.textLightBlack),
                          ),
                        ])),
                    const Gap(12),
                    (widget.productData.productDiscountRate == null)
                        ? Row(children: [
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
                                ]),
                              ),
                            ),
                          ])
                        : Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: RichText(
                                  maxLines: 2,
                                  text: TextSpan(
                                    children: [
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
                                        text: "₹ ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.textBlack),
                                      ),
                                      const TextSpan(
                                        text: "3000",
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.textBlack),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(16),
                              Flexible(
                                  child: PercentageShowContainerWidget(
                                      width: 80,
                                      height: 32,
                                      text: '41% off',
                                      textColor: BColors.white,
                                      boxColor: BColors.offRed)),
                            ],
                          ),
                    const Gap(16),
                    const ProductDetailsStraightWidget(
                      title: 'Product type : ',
                      text: 'Diabetes Monitoring',
                    ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductInfoWidget(
                            text1: 'Product Form :',
                            text2: (widget.productData.productFormNumber
                                        .toString()
                                        .isEmpty ||
                                    widget.productData.productFormNumber
                                            .toString() ==
                                        '1')
                                ? widget.productData.productForm ?? ''
                                : '${widget.productData.productFormNumber ?? ''} ${widget.productData.productForm ?? ''}'),
                        ProductInfoWidget(
                          text1: 'Product Package :',
                          text2: (widget.productData.productPackageNumber
                                      .toString()
                                      .isEmpty ||
                                  widget.productData.productPackageNumber
                                          .toString() ==
                                      '1')
                              ? widget.productData.productPackage ?? ''
                              : '${widget.productData.productPackageNumber ?? ''} ${widget.productData.productPackage ?? ''}',
                        ),
                        ProductInfoWidget(
                          text1: 'Ideal For :',
                          text2: widget.productData.idealFor ?? 'Everyone',
                        ),
                      ],
                    ),
                    const Gap(16),
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
                    child: (widget.productData.keyIngrdients != null)
                        ? ProductDetailsStraightWidget(
                            title: 'Key Ingredients : ',
                            text: widget.productData.keyIngrdients ??
                                'Unknown Ingredients',
                          )
                        : ProductDetailsStraightWidget(
                            title: 'Box Contains : ',
                            text: widget.productData.productBoxContains ??
                                'Unknown Items',
                          )),
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
                          ),
                        ),
                        const Gap(16),
                        const Flexible(
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
                        text1: 'Measurement :',
                        text2: '50 - mg',
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
      bottomSheet:
          Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
        return Container(
                width: double.infinity,
                height: 72,
                decoration: const BoxDecoration(
                    color: BColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                child:(!pharmacyProvider.bottomsheetCart)? Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8, right: 24),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ButtonWidget(
                      onPressed: () {
                        pharmacyProvider.bottomsheetSwitch(true);
                      },
                      buttonHeight: 48,
                      buttonWidth: 160,
                      buttonColor: BColors.offRed,
                      buttonWidget: const Text(
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
                ):Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8, right: 24, left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     const QuantityCountWidget(),
                      ButtonWidget(
                        onPressed: () {
                          pharmacyProvider.bottomsheetSwitch(false);
                        },
                        buttonHeight: 48,
                        buttonWidth: 160,
                        buttonColor: BColors.darkblue,
                        buttonWidget: const Text(
                          'Go to Cart',
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
                )
              );
            
      }),
    );
  }
}
