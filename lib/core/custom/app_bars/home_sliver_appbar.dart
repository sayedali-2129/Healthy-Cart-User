import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/notifications/presentation/notification_screen.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:page_transition/page_transition.dart';

class HomeSliverAppbar extends StatelessWidget {
  const HomeSliverAppbar({
    super.key,
    required this.searchHint,
    this.searchController,
    this.onChanged,
  });

  final String searchHint;
  final TextEditingController? searchController;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      toolbarHeight: 0,
      pinned: true,
      floating: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            const Gap(45),
            Image.asset(
              BImage.appBarImage,
              scale: 2.8,
            ),
          ],
        ),
      ),
      backgroundColor: BColors.mainlightColor,
      titleSpacing: 0,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text(
                      'Nilambur, Malappuram, Kerala',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: BColors.darkblue),
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 42,
                        child: TextField(
                          onChanged: onChanged,
                          controller: searchController,
                          showCursor: false,
                          cursorColor: BColors.black,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 4, 8, 4),
                            hintText: searchHint,
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(
                              Icons.search_outlined,
                              color: BColors.darkblue,
                            ),
                            filled: true,
                            fillColor: BColors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(3),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            EasyNavigation.push(
                                context: context,
                                type: PageTransitionType.topToBottom,
                                duration: 400,
                                page: const NotificationScreen());
                          },
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: BColors.buttonDarkColor,
                            size: 35,
                          ),
                        ),
                        const Positioned(
                          right: 2,
                          top: 2,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
