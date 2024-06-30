
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ProductDetailsWidget extends StatelessWidget {
  const ProductDetailsWidget({
    super.key,
    required this.productData,
    this.index,
  });
  final ProductAndQuantityModel productData;
  final int? index;
  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(56),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(56),
              child: CustomCachedNetworkImage(
                  image:  productData.productData?.productImage?.first ?? '')),
        ),
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productData.productData?.productName ?? 'Unknown Name',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'by ', // remeber to put space
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                    TextSpan(
                        text: productData.productData?.productBrandName ??
                            'Unkown Brand',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: BColors.textBlack,
                            )),
                  ]),
                ),
                (productData.productData?.productDiscountRate == null)
                    ? RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Price : ',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11),
                          ),
                          TextSpan(
                            text: "₹ ",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: BColors.green),
                          ),
                          TextSpan(
                            text:
                                '${productData.productData?.productMRPRate}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: BColors.green),
                          ),
                        ]),
                      )
                    : RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Price : ',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11),
                          ),
                          TextSpan(
                              text: "₹ ",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: BColors.green)),
                          TextSpan(
                            text:
                                '${productData.productData?.productDiscountRate}',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: BColors.green),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                              text: "₹ ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      decoration:
                                          TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: BColors.textBlack)),
                          TextSpan(
                            text:
                                '${productData.productData?.productMRPRate}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    color: BColors.textBlack),
                          ),
                        ]),
                      ),
                RichText(
                  text: TextSpan(
                    children: [
                    TextSpan(
                      text: (productData.productData?.productFormNumber != null)
                          ? '${productData.productData?.productFormNumber} '
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack,
                              fontSize: 11),
                    ),
                    TextSpan(
                      text: (productData.productData?.productForm != null)
                          ? '${productData.productData?.productForm}, '
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack,
                              fontSize: 11),
                    ),
                    TextSpan(
                      text: (productData.productData?.productPackageNumber != null)
                          ? '${productData.productData?.productPackageNumber} ' : '',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack,
                              fontSize: 11),
                    ),
                    TextSpan(
                      text: (productData.productData?.productPackage != null)
                          ? '${productData.productData?.productPackage}, '
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack,
                              fontSize: 11),
                    ),
                    TextSpan(
                      text: (productData
                                  .productData?.productMeasurementNumber !=
                              null)
                          ? '${productData.productData?.productMeasurementNumber} '
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack,
                              fontSize: 11),
                    ),
                    TextSpan(
                      text: (productData.productData?.productMeasurement !=
                              null)
                          ? '${productData.productData?.productMeasurement} '
                          : '',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: BColors.textBlack,
                              fontSize: 11),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
        Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: QuantitiyBox(
              productQuantity: '${productData.quantity}',
            ))
      ],
    );
  }
}
