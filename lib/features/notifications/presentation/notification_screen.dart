import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/custom_tab_bar.dart';
import 'package:healthy_cart_user/features/notifications/application/provider/notification_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<NotificationProvider>(builder: (context, notiPtovider, _) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
                title: 'Notifications',
                onBackTap: () => Navigator.pop(context)),
            const SliverGap(10),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: CustomTabBar(
                  screenWidth: screenWidth,
                  text1: 'Appointments',
                  text2: 'Orders',
                  tab1Color: notiPtovider.selectedTab
                      ? BColors.mainlightColor
                      : BColors.white,
                  tab2Color: notiPtovider.selectedTab
                      ? BColors.white
                      : BColors.mainlightColor,
                  onTapTab1: () => notiPtovider.tabSelection(true),
                  onTapTab2: () => notiPtovider.tabSelection(false),
                ),
              ),
            ),
            const SliverGap(10),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: screenWidth,
                    height: 150,
                    decoration: BoxDecoration(
                      color: BColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: BColors.black.withOpacity(0.3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
