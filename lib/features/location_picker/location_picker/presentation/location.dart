import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeInUp(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(BLottie.lottieLocation, height: 232),
                const Gap(24),
                const Text('Tap below to select your current location.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BColors.textLightBlack,
                        fontFamily: 'Montserrat'),
                        ),
                const Gap(40),
                (locationProvider.locationGetLoading)
                    ? const SizedBox(
                        height: 48,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              color: BColors.darkblue,
                            ),
                          ),
                        ),
                      )
                    : ButtonWidget(
                        buttonWidth: double.infinity,
                        buttonHeight: 48,
                        onPressed: () {
                          locationProvider.getLocationPermisson().then(
                            (value) {
                              if (value == true) {
                                EasyNavigation.push(
                                    context: context,
                                    page: const UserLocationSearchWidget());
                              }
                            },
                          );
                        },
                        buttonWidget: const Text('Pick Your Location',
                            style: TextStyle(
                                color: BColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        buttonColor: BColors.buttonLightColor,
                      ),
                const Gap(16),
              ],
            ),
          ),
        );
      }),
    );
  }
}
