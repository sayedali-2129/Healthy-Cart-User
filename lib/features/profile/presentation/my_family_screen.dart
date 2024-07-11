import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_bottom_sheet.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_list_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class MyFamilyScreen extends StatefulWidget {
  const MyFamilyScreen({super.key, required this.userId});
  final String userId;

  @override
  State<MyFamilyScreen> createState() => _MyFamilyScreenState();
}

class _MyFamilyScreenState extends State<MyFamilyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserAddressProvider>();
      provider.getUserAddress(userId: widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, UserAddressProvider>(
        builder: (context, provider, addressProvider, _) {
      return PopScope(
        onPopInvoked: (didPop) {
          addressProvider.selectedAddress = null;
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverCustomAppbar(
                title: 'Saved Addresses',
                onBackTap: () {
                  EasyNavigation.pop(context: context);
                },
              ),
              const SliverGap(16),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: provider.userFetchlDataFetched!.image == null
                          ? Image.asset(
                              BImage.userAvatar,
                              fit: BoxFit.cover,
                            )
                          : CustomCachedNetworkImage(
                              image: provider.userFetchlDataFetched!.image!,
                            ),
                    ),
                    const Gap(8),
                    Text(
                      provider.userFetchlDataFetched!.userName ?? 'User',
                      style: const TextStyle(
                          fontSize: 18,
                          color: BColors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    provider.userFetchlDataFetched!.placemark == null
                        ? const Gap(0)
                        : Text(
                            '${provider.userFetchlDataFetched!.placemark?.localArea}, ${provider.userFetchlDataFetched!.placemark?.district}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: BColors.black,
                                fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              const SliverGap(10),
              const SliverToBoxAdapter(
                child: Divider(),
              ),
              if (addressProvider.isLoading == true &&
                  addressProvider.userAddressList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (addressProvider.userAddressList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        BImage.noDataPng,
                        scale: 2.5,
                      ),
                      const Gap(15),
                      const Text(
                        'No Saved Address Found!',
                        style: TextStyle(
                            fontSize: 14,
                            color: BColors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )),
                )
              else
                SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: addressProvider.userAddressList.length,
                      separatorBuilder: (context, index) => const Gap(10),
                      itemBuilder: (context, index) => AddressListCard(
                        isDeleteAvailable: true,
                        index: index,
                      ),
                    )),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonWidget(
              buttonHeight: 40,
              buttonWidth: double.infinity,
              buttonColor: BColors.mainlightColor,
              buttonWidget: const Text(
                'Add New +',
                style: TextStyle(color: BColors.white),
              ),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: BColors.white,
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) => const AddressBottomSheet(),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
