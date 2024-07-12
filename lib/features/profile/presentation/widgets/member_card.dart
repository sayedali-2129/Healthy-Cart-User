// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_family_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/address_list_container.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/member_bottom_sheet.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/member_list_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class MembersCard extends StatelessWidget {
  const MembersCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserFamilyMembersProvider>(
        builder: (context, familyMemberProvider, _) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                familyMemberProvider.userFamilyMemberList.isEmpty
                    ? 'No Saved Members Found!'
                    : 'Booking For :-',
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
                            familyMemberProvider.userFamilyMemberList.isEmpty
                                ? 'Add Member'
                                : 'Change Member',
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
                                    const FamilyMemberBottomSheet(),
                              ).then(
                                (value) {
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: const Row(
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
                        child: familyMemberProvider.userFamilyMemberList.isEmpty
                            ? const NoDataImageWidget(
                                text: 'No Saved Members Found!',
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(8),
                                shrinkWrap: true,
                                itemCount: familyMemberProvider
                                    .userFamilyMemberList.length,
                                itemBuilder: (context, index) =>
                                    FamilyMemberListCard(
                                  isDeleteAvailable: false,
                                  index: index,
                                  onTap: () {
                                    familyMemberProvider
                                        .setSelectedFamilyMember(
                                            familyMemberProvider
                                                .userFamilyMemberList[index]);
                                    Navigator.pop(context);
                                  }, 
                                  familyMember:familyMemberProvider
                                                .userFamilyMemberList[index] ,
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
                      familyMemberProvider.userFamilyMemberList.isEmpty
                          ? 'Add Member'
                          : 'Change Member',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
          familyMemberProvider.userFamilyMemberList.isEmpty
              ? const Gap(0)
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            familyMemberProvider.selectedFamilyMember == null
                                ? familyMemberProvider
                                        .userFamilyMemberList.first.name ??
                                    'Unknown Member'
                                : familyMemberProvider
                                        .selectedFamilyMember?.name ??
                                    'Unknown Member',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const Gap(8),
                          Text(
                            'Age : ${familyMemberProvider.selectedFamilyMember == null ? familyMemberProvider.userFamilyMemberList.first.age ?? 'Unknown age' : familyMemberProvider.selectedFamilyMember!.age ?? 'Unknown age'}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const Gap(4),
                          Text(
                            'Gender : ${familyMemberProvider.selectedFamilyMember == null ? familyMemberProvider.userFamilyMemberList.first.gender ?? 'Unknown gender' : familyMemberProvider.selectedFamilyMember!.gender ?? 'Unknown gender'}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const Gap(4),
                          Text(
                            'Place : ${familyMemberProvider.selectedFamilyMember == null
                                ? familyMemberProvider
                                        .userFamilyMemberList.first.place ??
                                    'Unknown place'
                                : familyMemberProvider
                                        .selectedFamilyMember!.place ??
                                    'Unknown place'}',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const Gap(4),
                          Text(
                            'Phone No : ${familyMemberProvider.selectedFamilyMember == null ? familyMemberProvider.userFamilyMemberList.first.phoneNo ?? 'Unknown phone number' : familyMemberProvider.selectedFamilyMember!.phoneNo ?? 'Unknown phone number'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const Gap(4),
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
