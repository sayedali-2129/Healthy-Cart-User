import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/features/notifications/application/provider/notification_provider.dart';
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
          ],
        ),
      );
    });
  }
}
