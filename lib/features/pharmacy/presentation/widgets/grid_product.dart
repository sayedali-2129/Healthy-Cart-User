import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/container/custom_round_container.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_details.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PostCardVertical extends StatefulWidget {
  const PostCardVertical({
    required this.productData,
    super.key,
  });
  final PharmacyProductAddModel productData;
  @override
  State<PostCardVertical> createState() => _PostCardVerticalState();
}

class _PostCardVerticalState extends State<PostCardVertical> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyProvider = Provider.of<PharmacyProvider>(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      child: InkWell(
        onTap: () {
          pharmacyProvider.selectedIndex =
              0; // to make the  the first index as 0 of image url list
          pharmacyProvider
              .setProductImageList(widget.productData.productImage ?? []);
          EasyNavigation.push(
            context: context,
            type: PageTransitionType.bottomToTop,
            page: ProductDetailsScreen(
              productData: widget.productData,
              fromCart: false,
            ),
          );
         
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: BColors.lightGrey,
                blurRadius: 2.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(top: 12, left: 6, right: 6, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundedContainer(
                    height: 152,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    backgroundColor: BColors.lightGrey,
                    child: RoundedImage(
                        backgroundColor: BColors.white,
                        applyBorderRadius: true,
                        child: CustomCachedNetworkImage(
                          image: widget.productData.productImage?.first ??
                              BImage.healthycartText,
                          fit: BoxFit.fitHeight,
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title of the vertical widget
                        Text(
                          widget.productData.productName ?? 'Unknown Name',
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: BColors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                        const Gap(8),
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.black),
                              ),
                            ])),
                        const Gap(8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: const TextSpan(children: [
                                  TextSpan(
                                    text:
                                        'Category  :  ', // remeber to put space
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: BColors.textLightBlack),
                                  ),
                                ])),
                            Expanded(
                              child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: widget.productData.category ??
                                          'Unknown',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: BColors.black),
                                    ),
                                  ])),
                            ),
                          ],
                        ),
                        const Gap(8),

                        (widget.productData.productDiscountRate == null)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
                                        text: 'Our price  :  ',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.textLightBlack),
                                      ),
                                      TextSpan(
                                          text: "₹ ",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.green,
                                          )),
                                      TextSpan(
                                        text:
                                            '${widget.productData.productMRPRate ?? 0}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.green),
                                      ),
                                    ]),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: const TextSpan(children: [
                                    TextSpan(
                                      text: 'Our price  :  ',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: BColors.textLightBlack),
                                    )
                                  ])),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: "₹ ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: BColors.green,
                                              )),
                                          TextSpan(
                                            text:
                                                '${widget.productData.productDiscountRate ?? 0}',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: BColors.green),
                                          ),
                                        ])),
                                        RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(children: [
                                              const TextSpan(
                                                  text: "₹ ",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: BColors.black,
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                              TextSpan(
                                                  text:
                                                      '${widget.productData.productMRPRate ?? 0}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: BColors.textBlack,
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                            ])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.productData.productDiscountRate != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 12),
                      child: PercentageShowContainerWidget(
                        text:
                            '${widget.productData.discountPercentage ?? 0}% off',
                        textColor: BColors.textWhite,
                        boxColor: BColors.offRed,
                        width: 74,
                        height: 32,
                      ),
                    ),
                  if (widget.productData.inStock == false)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 6, right: 8, left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: BColors.red,
                          ),
                          const Gap(4),
                          const Text(
                            'Out of stock',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: BColors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
