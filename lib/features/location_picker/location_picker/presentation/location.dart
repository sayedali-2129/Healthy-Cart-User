import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: FadeInUp(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(BLottie.lottieLocation, height: 232),
                    const Gap(62),
                    const Text(
                      'Tap below to select your current location.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BColors.textLightBlack,
                          fontFamily: 'Montserrat'),
                    ),
                    (locationProvider.locationGetLoading)
                        ? const Gap(0)
                        : const Gap(24),
                    (locationProvider.locationGetLoading)
                        ? const Center(
                            child: LoadingIndicater(),
                          )
                        : ButtonWidget(
                            buttonWidth: double.infinity,
                            buttonHeight: 48,
                            onPressed: () {
                              locationProvider.getLocationPermisson().then(
                                (value) {
                                  if (value == true) {
                                    locationProvider
                                        .getCurrentLocationAddress()
                                        .whenComplete(
                                      () {
                                        if (locationProvider
                                                .selectedPlaceMark ==
                                            null) {
                                          CustomToast.errorToast(
                                              text:
                                                  "Couldn't able to get the location,please try again");
                                          return;
                                        }
                                        locationProvider
                                            .saveLocationLocally(
                                                locationProvider
                                                    .selectedPlaceMark!)
                                            .whenComplete(
                                          () {
                                            locationProvider.setLocationByUser(
                                              context: context,
                                              isUserEditProfile: false,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            },
                            buttonWidget: const Text('Pick Your Location',
                                style: TextStyle(
                                    color: BColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            buttonColor: BColors.darkblue,
                          ),
                    const Gap(16),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
