import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/features/notifications/domain/i_notification_facade.dart';
import 'package:healthy_cart_user/features/notifications/domain/models/notification_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationProvider with ChangeNotifier {
  NotificationProvider(this.iNotificationFacade);
  final INotificationFacade iNotificationFacade;

  bool isLoading = false;

  Future<void> notificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
    notifyListeners();
  }

  /* -------------------------- GET ALL NOTIFICATION -------------------------- */
  List<NotificationModel> notificationList = [];
  Future<void> getAllNotifications() async {
    isLoading = true;
    notifyListeners();

    final result = await iNotificationFacade.getAllNotifications();
    result.fold((err) {
      CustomToast.errorToast(text: 'Unable get notifications');
      log('ERROR :: ${err.errMsg}');
    }, (success) {
      notificationList.addAll(success);
    });
    isLoading = false;
    notifyListeners();
  }

  void clearNotificationData() {
    iNotificationFacade.clearNotificationData();
    notificationList = [];
    notifyListeners();
  }

  void notiInit(ScrollController scrollcontroller) {
    scrollcontroller.addListener(
      () {
        if (scrollcontroller.position.atEdge &&
            scrollcontroller.position.pixels != 0 &&
            isLoading == false) {
          getAllNotifications();
        }
      },
    );
  }
}
