// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_bottom_sheet.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class AddressListCard extends StatelessWidget {
  const AddressListCard({
    super.key,
    required this.index,
    this.onTap,
    required this.isDeleteAvailable,
  });
  final int index;
  final void Function()? onTap;
  final bool isDeleteAvailable;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserAddressProvider, AuthenticationProvider>(
        builder: (context, addressProvider, authProvider, _) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          // height: 100,
          decoration: BoxDecoration(
            color: BColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: BColors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                addressProvider.userAddressList[index].name ??
                                    'User',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const Gap(8),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Center(
                                    child: Text(
                                      addressProvider.userAddressList[index]
                                              .addressType ??
                                          'Home',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(5),
                          Text(
                            '${addressProvider.userAddressList[index].address ?? 'Address'} ${addressProvider.userAddressList[index].landmark ?? 'Landmark'} - ${addressProvider.userAddressList[index].pincode ?? 'Pincode'}',
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 3,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const Gap(5)
                        ],
                      ),
                      Text(
                        addressProvider.userAddressList[index].phoneNumber ??
                            'Phone',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const Gap(8),
                PopupMenuButton(
                  color: BColors.white,
                  child: const Icon(
                    Icons.edit_outlined,
                    color: BColors.black,
                    size: 26,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: BColors.white,
                          isScrollControlled: true,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => AddressBottomSheet(
                            userAddressModel:
                                addressProvider.userAddressList[index],
                            index: index,
                          ),
                        );
                      },
                      child: Text(
                        'Edit',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (isDeleteAvailable == true)
                      PopupMenuItem(
                        onTap: () {
                          ConfirmAlertBoxWidget.showAlertConfirmBox(
                              context: context,
                              confirmButtonTap: () async {
                                LoadingLottie.showLoading(
                                    context: context,
                                    text: 'Removing Address...');
                                await addressProvider.removeAddress(
                                    userId:
                                        authProvider.userFetchlDataFetched!.id!,
                                    addressId: addressProvider
                                        .userAddressList[index].id!,
                                    index: index);
                                Navigator.pop(context);
                              },
                              titleText: 'Remove',
                              subText:
                                  'Are you sure want to remove the adress?');
                        },
                        child: Text(
                          'Remove',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
