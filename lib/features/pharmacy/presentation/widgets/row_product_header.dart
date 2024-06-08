import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_categories.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/vertical_image_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:page_transition/page_transition.dart';

class RowProductCategoryWidget extends StatelessWidget {
  const RowProductCategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat'),
                ),
                ButtonWidget(
                  buttonColor: BColors.buttonGreen,
                  onPressed: () {},
                  buttonHeight: 36,
                  buttonWidth: 176,
                  buttonWidget: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.maps_ugc_outlined,
                        color: BColors.textBlack,
                        size: 24,
                      ),
                      Text(
                        'Prescription',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: BColors.textBlack),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              EasyNavigation.push(
                  context: context,
                  type: PageTransitionType.leftToRight,
                  page: const PharmacyCategoriesScreen());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 24, bottom: 4),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'View All',
                  style: TextStyle(
                      decorationThickness: 2,
                      decoration: TextDecoration.underline,
                      decorationColor: BColors.darkblue,
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: BColors.darkblue),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 96,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const VerticalImageText(
                      image: BImage.roundedSplashLogo, title: 'Categoriess');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
