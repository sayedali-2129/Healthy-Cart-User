import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/search_field_button.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class UserLocationSearchWidget extends StatefulWidget {
  const UserLocationSearchWidget({
    super.key,
    this.isUserEditProfile,
  });
  final bool? isUserEditProfile;

  @override
  State<UserLocationSearchWidget> createState() =>
      _UserLocationSearchWidgetState();
}

class _UserLocationSearchWidgetState extends State<UserLocationSearchWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = context.read<LocationProvider>();
      locationProvider
        ..clearLocationData()
        ..getCurrentLocationAddress();
    });
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('search');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer2<LocationProvider, AuthenticationProvider>(
        builder: (context, locationProvider, authProvider, _) {
      return CustomScrollView(slivers: [
        SliverAppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: BColors.mainlightColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8))),
          title: const Text(
            'Choose Location',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          shadowColor: BColors.black.withOpacity(0.8),
          elevation: 5,
        ),
        SliverPadding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
          sliver: SliverToBoxAdapter(
            child: SearchTextFieldButton(
              text: 'Search city, area or place',
              onSubmit: (val) {
                if (val.isEmpty) return;
                locationProvider.searchPlaces();
              },
              controller: locationProvider.searchController,
              onChanged: (val) {
                if (val.isEmpty) return;
                EasyDebounce.debounce(
                    'search', const Duration(milliseconds: 300), () {
                  locationProvider.searchPlaces();
                });
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: InkWell(
            onTap: () async {
              if (locationProvider.selectedPlaceMark == null) return;
              LoadingLottie.showLoading(
                  context: context, text: 'Getting Location...');
              await locationProvider.setLocationByUser(
                context: context,
                isUserEditProfile: widget.isUserEditProfile ?? false,
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 4),
              child: SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.my_location_rounded,
                          color: BColors.darkblue,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 260,
                                child: Row(
                                  children: [
                                    const SizedBox(),
                                    Expanded(
                                      child: Text(
                                        overflow: TextOverflow.clip,
                                        (locationProvider.selectedPlaceMark != null)
                                            ? "${locationProvider.selectedPlaceMark?.localArea},${locationProvider.selectedPlaceMark?.district},${locationProvider.selectedPlaceMark?.state}"
                                            : "Getting current location...",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: BColors.darkblue,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                (locationProvider.searchLoading)
                                    ? "Getting location, please wait..."
                                    : "Tap to save the location above.",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
            ),
          ),
        ),
        if (locationProvider.searchLoading)
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 4),
            child: LinearProgressIndicator(
              color: BColors.darkblue,
            ),
          )),
        if (locationProvider.searchResults.isEmpty)
          SliverFillRemaining(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: BColors.mainlightColor,
                ),
                const Gap(8),
                Text(
                  'Search result will be shown here',
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            )),
          ),
        if (locationProvider.searchResults.isNotEmpty)
          SliverList.builder(
            itemCount: locationProvider.searchResults.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: ListTile(
                    title: Text(
                      "${locationProvider.searchResults[index].localArea},${locationProvider.searchResults[index].district},${locationProvider.searchResults[index].state}",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    trailing: const Icon(
                      Icons.north_west_outlined,
                      color: BColors.buttonDarkColor,
                      size: 20,
                    ),
                    onTap: () {
                      locationProvider.setSelectedPlaceMark(
                          locationProvider.searchResults[index]);
                    },
                  ),
                ),
              );
            },
          ),
      ]);
    }));
  }
}
