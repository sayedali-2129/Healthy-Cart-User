import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_profile_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class UserImageContainer extends StatelessWidget {
  const UserImageContainer({
    super.key,
    this.userModel,
  });
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
        builder: (context, profileProvider, _) {
      return SizedBox(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                profileProvider.pickUserImage();
              },
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    height: 85,
                    width: 85,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: (profileProvider.imageFile == null &&
                            profileProvider.imageUrl == null)
                        ? Image.asset(
                            BImage.userAvatar,
                            fit: BoxFit.cover,
                          )
                        : (profileProvider.imageFile != null)
                            ? Image.file(
                                profileProvider.imageFile!,
                                fit: BoxFit.cover,
                              )
                            : CustomCachedNetworkImage(
                                image: profileProvider.imageUrl!),
                  ),
                  profileProvider.imageFile == null &&
                          profileProvider.imageUrl == null
                      ? const Positioned(
                          bottom: 3,
                          right: 3,
                          child: CircleAvatar(
                              radius: 12,
                              backgroundColor: BColors.darkblue,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 15,
                                color: BColors.offWhite,
                              )))
                      : const Gap(0),
                  profileProvider.imageUrl == null &&
                          profileProvider.imageFile == null
                      ? const Gap(0)
                      : Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Image',
                                      style: TextStyle(
                                          color: BColors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  content: const Text(
                                      'Are you sure you want to delete profile image?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileProvider.removeProfileImage();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes'))
                                  ],
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: BColors.red,
                              child: const Icon(
                                Icons.close,
                                size: 15,
                                color: BColors.white,
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
