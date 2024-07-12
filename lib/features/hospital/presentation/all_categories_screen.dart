import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/all_doctors_screen.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/vertical_image_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({
    super.key,
 
  });
  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
              onPressed: () => EasyNavigation.pop(context:context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),),
          backgroundColor: BColors.mainlightColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  ),
                  ),
          title: const Text(
            'All Categories',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          shadowColor: BColors.black.withOpacity(0.8),
          elevation: 5,
        ),
        body: GridView.builder(
          itemCount: hospitalProvider.hospitalAllCategoryList.length,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisExtent: 110),
          itemBuilder: (context, categoryIndex) {
            final category =
                hospitalProvider.hospitalAllCategoryList[categoryIndex];
            return FadeInRight(
              duration: const Duration(milliseconds: 500),
              child: VerticalImageText(
                  rightPadding: 8,
                  leftPadding: 0,
                  onTap: () {
                    EasyNavigation.push(
                        context: context,
                        type: PageTransitionType.rightToLeft,
                        duration: 250,
                        page: AllDoctorsScreen(
                          category: category,  
                        ),
                        );
                  },
                  image: hospitalProvider
                      .hospitalAllCategoryList[categoryIndex].image!,
                  title: hospitalProvider
                      .hospitalAllCategoryList[categoryIndex].category!),
            );
          },
        ),
      );
    });
  }
}
