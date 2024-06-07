import 'package:flutter/material.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/profile_buttons.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/profile_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
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
                ProfileCard(
                  userName: authProvider.userFetchlDataFetched!.userName,
                  userLocation:
                      authProvider.userFetchlDataFetched!.placemark!.localArea,
                  userIamge: authProvider.userFetchlDataFetched!.image,
                ),
                ProfileButtons(
                  buttonName: 'Edit Profile',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileSetup(
                            userModel: authProvider.userFetchlDataFetched,
                          ),
                        ));
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
                  onPressed: () {},
                ),
              ],
            ),
          ));
    });
  }
}
