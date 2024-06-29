import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/my_address_screen.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/profile_buttons.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, _) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: BColors.mainlightColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            title: Image.asset(
              BImage.appBarImage,
              scale: 3,
            ),
            centerTitle: true,
            shadowColor: BColors.black.withOpacity(0.8),
            elevation: 5,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FadeInRight(
                  child: ProfileCard(
                    userName: authProvider.userFetchlDataFetched!.userName,
                    userLocation:
                        '${authProvider.userFetchlDataFetched!.placemark?.localArea}, ${authProvider.userFetchlDataFetched!.placemark?.district}',
                    userImage: authProvider.userFetchlDataFetched!.image,
                  ),
                ),
                FadeInUp(
                  child: Column(
                    children: [
                      ProfileButtons(
                        buttonName: 'Edit Profile',
                        onPressed: () {
                          EasyNavigation.push(
                            type: PageTransitionType.rightToLeft,
                            duration: 300,
                            context: context,
                            page: ProfileSetup(
                              userModel: authProvider.userFetchlDataFetched,
                            ),
                          );
                        },
                      ),
                      ProfileButtons(
                        buttonName: 'My Appointments',
                        onPressed: () {},
                      ),
                      ProfileButtons(
                        buttonName: 'My Orders',
                        onPressed: () {},
                      ),
                      ProfileButtons(
                        buttonName: 'My Cart',
                        onPressed: () {},
                      ),
                      ProfileButtons(
                        buttonName: 'My Address',
                        onPressed: () {
                          EasyNavigation.push(
                              type: PageTransitionType.rightToLeft,
                              duration: 300,
                              context: context,
                              page: MyAddressScreen(
                                userId: authProvider.userFetchlDataFetched!.id!,
                              ));
                        },
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlineButtonWidget(
                            buttonHeight: 40,
                            buttonWidth: 160,
                            buttonColor: Colors.transparent,
                            borderColor: BColors.black,
                            onPressed: () {},
                            buttonWidget: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.add_ic_call_sharp,
                                  color: BColors.black,
                                ),
                                Text(
                                  'Contact Us',
                                  style: TextStyle(color: BColors.black),
                                )
                              ],
                            ),
                          ),
                          ButtonWidget(
                            buttonHeight: 40,
                            buttonWidth: 160,
                            buttonColor: BColors.mainlightColor,
                            onPressed: () {
                              ConfirmAlertBoxWidget.showAlertConfirmBox(
                                  context: context,
                                  confirmButtonTap: () async {
                                    LoadingLottie.showLoading(
                                        context: context, text: 'Logging Out...');
                                    await authProvider.userLogOut(
                                        context: context);
                                  },
                                  titleText: 'Log Out',
                                  subText: 'Are you sure want to logout?');
                            },
                            buttonWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Log Out',
                                  style: TextStyle(color: BColors.white),
                                ),
                                Image.asset(
                                  BIcon.logoutIcon,
                                  scale: 4,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
