import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({
    super.key,
    required this.locationSetter,
  });
  final int locationSetter;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
         WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            context.read<LocationProvider>().setUserId(context
                    .read<AuthenticationProvider>()
                    .userFetchlDataFetched?.id);
          },
        );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<LocationProvider, AuthenticationProvider>(
          builder: (context, locationProvider, authProvider, _) {
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
                    const Gap(80),
                    const Text(
                      'Tap to continue with your current location.',
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
                                        if (locationProvider.userId != null) {
                                          locationProvider.setLocationOfUser(
                                            context: context,
                                            isUserEditProfile: false,
                                            locationSetter: widget.locationSetter,
                                            onSucess: () {
                                              EasyNavigation.pushReplacement(
                                                  context: context,
                                                  page:
                                                      const BottomNavigationWidget());
                                            },
                                          );
                                        } else {
                                          locationProvider.saveLocationLocally(
                                            isUserEditProfile: false,
                                            context: context,
                                            locationSetter: widget.locationSetter,
                                            onSucess: () {
                                              EasyNavigation.pushReplacement(
                                                  context: context,
                                                  page:
                                                      const BottomNavigationWidget());
                                            },
                                          );
                                        }
                                      },
                                    );
                                  } else {
                                    CustomToast.errorToast(
                                        text:
                                            "Please enable location to continue.");
                                  }
                                },
                              );
                            },
                            buttonWidget: const Text(
                              'Pick Your Location',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: BColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            buttonColor: BColors.darkblue,
                          ),
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
