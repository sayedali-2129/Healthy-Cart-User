// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/no_data_widget.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_bottom_sheet.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_list_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserAddressProvider>(
        builder: (context, addressProvider, _) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                addressProvider.userAddressList.isEmpty
                    ? 'No Saved Address Found!'
                    : 'Address :-',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: BColors.black),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: BColors.white,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            addressProvider.userAddressList.isEmpty
                                ? 'Add Address'
                                : 'Change Address',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: BColors.white,
                                isScrollControlled: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) =>
                                    const AddressBottomSheet(),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add),
                                Text(
                                  'Add New',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: 500,
                        width: 300,
                        child: addressProvider.userAddressList.isEmpty
                            ? const NoDataImageWidget(
                                text: 'No Saved Address Found!',
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(8),
                                shrinkWrap: true,
                                itemCount:
                                    addressProvider.userAddressList.length,
                                itemBuilder: (context, index) =>
                                    AddressListCard(
                                  index: index,
                                  onTap: () {
                                    addressProvider.setSelectedAddress(
                                        addressProvider.userAddressList[index]);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      addressProvider.userAddressList.isEmpty
                          ? 'Add Address'
                          : 'Change Address',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
          addressProvider.userAddressList.isEmpty
              ? const Gap(0)
              : Row(
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
                                    addressProvider.selectedAddress == null
                                        ? addressProvider
                                                .userAddressList.first.name ??
                                            'User'
                                        : addressProvider
                                                .selectedAddress!.name ??
                                            'User',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
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
                                          addressProvider.selectedAddress ==
                                                  null
                                              ? addressProvider.userAddressList
                                                      .first.addressType ??
                                                  'Home'
                                              : addressProvider.selectedAddress!
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
                                '${addressProvider.selectedAddress == null ? addressProvider.userAddressList.first.address ?? 'Address' : addressProvider.selectedAddress!.address} ${addressProvider.selectedAddress == null ? addressProvider.userAddressList.first.landmark ?? 'Address' : addressProvider.selectedAddress!.landmark} - ${addressProvider.selectedAddress == null ? addressProvider.userAddressList.first.pincode ?? 'Address' : addressProvider.selectedAddress!.pincode}',
                                // overflow: TextOverflow.ellipsis,
                                // maxLines: 3,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const Gap(5)
                            ],
                          ),
                          Text(
                            addressProvider.selectedAddress == null
                                ? addressProvider
                                        .userAddressList.first.phoneNumber ??
                                    'Address'
                                : addressProvider
                                        .selectedAddress!.phoneNumber ??
                                    '0000000000',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      );
    });
  }
}
