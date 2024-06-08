import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/product_details.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/percentage_shower_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:page_transition/page_transition.dart';

class PostCardVertical extends StatefulWidget {
  const PostCardVertical({
    super.key,
  });

  @override
  State<PostCardVertical> createState() => _PostCardVerticalState();
}

class _PostCardVerticalState extends State<PostCardVertical> {
  bool? isLiked;

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
          EasyNavigation.push(context: context,type: PageTransitionType.bottomToTop, page: ProductDetailsScreen());
        },
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedContainer(
                height: 144,
                padding: const EdgeInsets.all(12),
                backgroundColor: BColors.lightGrey,
                child: Stack(
                  children: [
                    //thumbnail Image
                    RoundedImage(
                      backgroundColor: BColors.white,
                      imageUrl: BImage.appBarImage,
                      onpressed: () {},
                      applyImageRadius: true,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title of the vertical widget
                    const Text(
                      'Gelusul 500 ml',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: BColors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                    const Gap(8),
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
                            text: 'Category  : ', // remeber to put space
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: BColors.textLightBlack),
                          ),
                          TextSpan(
                            text: 'Energy',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: BColors.black),
                          ),
                        ])),
                    const Gap(8),
                    //  (pharmacyProvider
                    //                                               .productList[
                    //                                                   index]
                    //                                               .productDiscountRate ==
                    //                                           null)
                    (false)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Our price : ',
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: BColors.black,
                                      )),
                                  TextSpan(
                                    text: "30000",
                                    style: TextStyle(
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
                            children: [
                              const Text(
                                'Our price : ',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.textLightBlack),
                              ),
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
                                        text: "25000",
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
                                        text: const TextSpan(children: [
                                          TextSpan(
                                              text: "₹ ",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: BColors.black,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                          TextSpan(
                                              text: "30000",
                                              style: TextStyle(
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
                    const Gap(8),
                    PercentageShowContainerWidget(
                      text: '25 %',
                      textColor: BColors.textWhite,
                      boxColor: BColors.offRed,
                      width: 64,
                      height: 24,
                    )
                  ],
                ),
              ),
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
      this.fit = BoxFit.contain,
      required this.onpressed,
      this.borderRadius = 12});

  final String imageUrl;
  final double? width;
  final double? height;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BoxFit? fit;
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
            child: CustomCachedNetworkImage(image: imageUrl)),
      ),
    );
  }
}
