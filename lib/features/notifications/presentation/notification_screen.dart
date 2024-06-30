import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/notifications/application/provider/notification_provider.dart';
import 'package:healthy_cart_user/features/notifications/presentation/widgets/notification_frame.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final scrollcontroller = ScrollController();
  @override
  void initState() {
    final provider = context.read<NotificationProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider
        ..clearNotificationData()
        ..getAllNotifications();
    });
    provider.notiInit(scrollcontroller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) => CustomScrollView(
          controller: scrollcontroller,
          slivers: [
            SliverCustomAppbar(
                title: 'Notifications',
                onBackTap: () => Navigator.pop(context)),

            //showing notification list
            if (provider.notificationList.isEmpty && provider.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: LoadingIndicater()),
              )
            else if (provider.notificationList.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                    child: NoDataImageWidget(text: 'No Notifications Found!')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(5),
                  itemCount: provider.notificationList.length,
                  itemBuilder: (context, index) => NotificationFrame(
                    notification: provider.notificationList[index],
                  ),
                ),
              ),
            //lazy loading
            SliverToBoxAdapter(
              child: (provider.isLoading == true &&
                      provider.notificationList.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
