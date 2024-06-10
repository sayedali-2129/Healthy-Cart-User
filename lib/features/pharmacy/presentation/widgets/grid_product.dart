import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_product_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_details.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:page_transition/page_transition.dart';

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
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: BColors.white,
      elevation: 10,
      child: InkWell(
        onTap: () {
          EasyNavigation.push(
              context: context,
              type: PageTransitionType.bottomToTop,
              page: ProductDetailsScreen(
                productData: widget.productData,
              ));
        },
        child: Container(
          width: 180,
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
                      imageUrl:widget.productData.productImage?.first ?? BImage.healthycartText,
                      onpressed: () {},
                      applyImageRadius: true,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: const TextSpan(children: [
                              TextSpan(
                                text: 'Category  :  ', // remeber to put space
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.textLightBlack),
                              ),
                              TextSpan(
                                text: 
                                    'Energy',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.black),
                              ),
                            ])),
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
                                     const TextSpan(
                                          text: "₹ ",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.black,
                                          )),
                                      TextSpan(
                                        text:
                                            '${widget.productData.productMRPRate ?? 0}',
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.black),
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
                                    text:const TextSpan(children: [
                                      TextSpan(
                                        text: 'Our price  :  ',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: BColors.textLightBlack),
                                      )])),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: "₹ ",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: BColors.green,
                                              )),
                                          TextSpan(
                                            text:  '${widget.productData.productDiscountRate ?? 0}',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: BColors.green),
                                          ),
                                        ])),
                                        RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text:  TextSpan(children: [
                                            const  TextSpan(
                                                  text: "₹ ",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: BColors.black,
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                              TextSpan(
                                                  text:  '${widget.productData.productMRPRate ?? 0}',
                                                  style: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
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
               if(widget.productData.productDiscountRate != null)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8, left: 12),
                            child: PercentageShowContainerWidget(
                              text: '${widget.productData.discountPercentage ?? 0} %',
                              textColor: BColors.textWhite,
                              boxColor: BColors.offRed,
                              width: 64,
                              height: 24,
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {super.key,
      this.width,
      this.height,
      this.radius = 14,
      this.child,
      this.showBorder = false,
      this.borderColor = BColors.black,
      this.backgroundColor = BColors.white,
      this.padding,
      this.margin});

  final double? width;
  final double? height;
  final double radius;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}

class RoundedImage extends StatelessWidget {
  const RoundedImage(
      {super.key,
      required this.imageUrl,
      this.width = 150,
      this.height = 150,
      this.applyImageRadius = false,
      this.border,
      this.backgroundColor = BColors.grey,
      this.padding,
     
      required this.onpressed,
      this.borderRadius = 12});

  final String imageUrl;
  final double? width;
  final double? height;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
 
  final VoidCallback onpressed;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            border: border,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: ClipRRect(
            borderRadius: applyImageRadius
                ? BorderRadius.circular(10)
                : BorderRadius.zero,
            child: CustomCachedNetworkImage(image: imageUrl, fit: BoxFit.scaleDown, )),
      ),
    );
  }
}
