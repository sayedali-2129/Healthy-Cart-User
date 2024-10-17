import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_cart.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/details_widgets.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/image_gallery_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_count_add.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(
      {super.key, required this.productData, required this.fromCart});
  final PharmacyProductAddModel productData;
  final bool fromCart;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final pharmacyProvider =
            Provider.of<PharmacyProvider>(context, listen: false);
        if (pharmacyProvider.cartProductMap.containsKey((productData.id))) {
          pharmacyProvider.quantityCount =
              pharmacyProvider.cartProductMap[productData.id];
        } else {
          pharmacyProvider.quantityCount = 1;
        }
      },
    );
    return Scaffold(
      body: Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
        return CustomScrollView(
          slivers: [
            SliverCustomAppbar(
              title: 'Product Info',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              },
            ),
            SliverAppBar(
              backgroundColor: BColors.white,
              automaticallyImplyLeading: false,
              toolbarHeight: 296,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(
                      top: 24, right: 16, left: 16, bottom: 16),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: const GalleryImagePicker(),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(32),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: BColors.lightGrey.withOpacity(.5),
                  surfaceTintColor: BColors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 16,
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
                        productData.productName ?? 'Unknown Name',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                            color: BColors.textBlack),
                      ),
                      const Gap(4),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                            text:
                                productData.productBrandName ?? 'Unknown Brand',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: BColors.textLightBlack),
                          ),
                        ]),
                      ),
                      const Gap(12),
                      (productData.productDiscountRate == null)
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
                                      text: "${productData.productMRPRate}",
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
                                          text:
                                              "${productData.productDiscountRate}",
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
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Montserrat',
                                              color: BColors.textBlack),
                                        ),
                                        TextSpan(
                                          text: "${productData.productMRPRate}",
                                          style: const TextStyle(
                                              fontSize: 14,
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
                                        text:
                                            '${productData.discountPercentage}% off',
                                        textColor: BColors.white,
                                        boxColor: BColors.offRed)),
                              ],
                            ),
                      if (productData.productType != null &&
                          productData.productType!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ProductDetailsStraightWidget(
                            title: 'Product type : ',
                            text: '${productData.productType}',
                          ),
                        ),
                      const Gap(16),
                      (productData.typeOfProduct != "Equipment")
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProductInfoWidget(
                                    text1: 'Product Form :',
                                    text2: (productData.productFormNumber
                                                .toString()
                                                .isEmpty ||
                                            productData.productFormNumber
                                                    .toString() ==
                                                '1')
                                        ? productData.productForm ?? ''
                                        : '${productData.productFormNumber ?? ''} ${productData.productForm ?? ''}'),
                                ProductInfoWidget(
                                  text1: 'Product Package :',
                                  text2: (productData.productPackageNumber
                                              .toString()
                                              .isEmpty ||
                                          productData.productPackageNumber
                                                  .toString() ==
                                              '1')
                                      ? productData.productPackage ?? ''
                                      : '${productData.productPackageNumber ?? ''} ${productData.productPackage ?? ''}',
                                ),
                                ProductInfoWidget(
                                  text1: 'Ideal For :',
                                  text2: productData.idealFor ?? 'Everyone',
                                ),
                              ],
                            )
                          : ProductDetailsStraightWidget(
                              title: 'Ideal For : ',
                              text: productData.idealFor ?? 'Everyone',
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
                      child: (productData.keyIngrdients != null)
                          ? ProductDetailsStraightWidget(
                              title: 'Key Ingredients : ',
                              text: productData.keyIngrdients ??
                                  'Unknown Ingredients',
                            )
                          : ProductDetailsStraightWidget(
                              title: 'Box Contains : ',
                              text: productData.productBoxContains ??
                                  'Unknown Items',
                            )),
                ),
              ),
            ),
            if (productData.productInformation != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                      color: BColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: TitleAndProductInformation(
                          title: 'Product Information : ',
                          content: productData.productInformation ?? '',
                        ),
                      )),
                ),
              ),
            if (productData.requirePrescription == true)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
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
                      ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        (productData.expiryDate == null)
                            ? ProductInfoWidget(
                                text1: 'Warranty Period :',
                                text2:
                                    '${productData.equipmentWarrantyNumber} ${productData.equipmentWarranty}',
                              )
                            : ProductInfoWidget(
                                text1: 'Expiry Date :',
                                text2: pharmacyProvider.expiryDateSetterFetched(
                                    productData.expiryDate ?? Timestamp.now()),
                              ),
                        if (productData.productMeasurementNumber != null &&
                            productData.productMeasurement != null)
                          ProductInfoWidget(
                            text1: 'Measured Quantity :',
                            text2:
                                '${productData.productMeasurementNumber} ${productData.productMeasurement}',
                          ),
                        if (productData.storingDegree != null &&
                            productData.storingDegree!.isNotEmpty)
                          ProductInfoWidget(
                            text1: 'Store Below :',
                            text2:
                                '${productData.storingDegree ?? 'Not mentioned'} °C',
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  color: BColors.white,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (productData.specification != null &&
                              productData.specification!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TitleAndProductInformation(
                                title: 'Specification : ',
                                content: productData.specification ?? '',
                              ),
                            ),
                          if (productData.keyBenefits != null &&
                              productData.keyBenefits!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TitleAndProductInformation(
                                title: 'Key Benefits : ',
                                content: productData.keyBenefits ?? '',
                              ),
                            ),
                          if (productData.directionToUse != null &&
                              productData.directionToUse!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TitleAndProductInformation(
                                title: 'Diection To Use : ',
                                content: productData.directionToUse ?? '',
                              ),
                            ),
                          if (productData.safetyInformation != null &&
                              productData.safetyInformation!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TitleAndProductInformation(
                                title: 'Safety Information : ',
                                content: productData.safetyInformation ?? '',
                              ),
                            ),
                          const Gap(24),
                          const Divider(),
                        ],
                      )),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: FadeInUp(
        child: BottomSheetAddToCart(
          productData: productData,
          fromCart: fromCart,
        ),
      ),
    );
  }
}

class TitleAndProductInformation extends StatelessWidget {
  const TitleAndProductInformation({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailsHeading(text: title),
        const Gap(6),
        Text(
          content,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: BColors.textBlack,
          ),
        ),
      ],
    );
  }
}

class BottomSheetAddToCart extends StatelessWidget {
  const BottomSheetAddToCart({
    super.key,
    required this.productData,
    required this.fromCart,
  });
  final PharmacyProductAddModel productData;
  final bool fromCart;
  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return (productData.inStock == false)
          ? Container(
              width: double.infinity,
              height: 80,
              decoration: const BoxDecoration(
                color: BColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: BColors.red,
                    ),
                    const Gap(8),
                    const Text(
                      'Item is currently out of stock',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BColors.darkblue),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: double.infinity,
              height: 80,
              decoration: const BoxDecoration(
                  color: BColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child:
                  (pharmacyProvider.cartProductMap.containsKey(productData.id))
                      ? Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, top: 8, right: 24, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 200,
                                child: ProductInfoWidget(
                                  fontSize1: 11,
                                  fontSize2: 12,
                                  text1: 'Quantity in cart : ',
                                  text2: 'This items already in your cart',
                                ),
                              ),
                              (!fromCart) // check wheather get to this page from cart or not
                                  ? ButtonWidget(
                                      onPressed: () {
                                        EasyNavigation.push(
                                          context: context,
                                          page: const ProductCartScreen(),
                                        );
                                      },
                                      buttonHeight: 48,
                                      buttonWidth: 144,
                                      buttonColor: BColors.darkblue,
                                      buttonWidget: const Text(
                                        'View Cart',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.white),
                                      ),
                                    )
                                  : ButtonWidget(
                                      onPressed: () {
                                        EasyNavigation.pop(context: context);
                                      },
                                      buttonHeight: 48,
                                      buttonWidth: 144,
                                      buttonColor: BColors.darkblue,
                                      buttonWidget: const Text(
                                        'Back to Cart',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            color: BColors.white),
                                      ),
                                    )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, top: 8, right: 24, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              QuantityCountWidget(
                                incrementTap: () {
                                  pharmacyProvider.increment();
                                },
                                decrementTap: () {
                                  pharmacyProvider.decrement();
                                },
                                quantityValue: pharmacyProvider.quantityCount,
                              ),
                              ButtonWidget(
                                onPressed: () {
                                  LoadingLottie.showLoading(
                                    context: context,
                                    text: 'Adding to cart...',
                                  );
                                  pharmacyProvider
                                      .addProductToUserCart(
                                    productId: productData.id ?? '',
                                    selectedQuantityCount:
                                        pharmacyProvider.quantityCount,
                                    cartQuantityIncrement: null,
                                  )
                                      .then(
                                    (value) {
                                      EasyNavigation.pop(context: context);
                                    },
                                  );
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
                            ],
                          ),
                        ));
    });
  }
}
