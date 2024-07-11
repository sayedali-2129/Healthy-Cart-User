import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthy_cart_user/core/di/injection.dart';

class ForegroundNotificationService {
  // static const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'Channel_id', 'channel_name',
  //     importance: Importance.high, playSound: true);

  // static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await configureDependancy();
  }

/* --------------------------------- ON MAIN -------------------------------- */
  static Future<void> messageInit(
      {required AndroidNotificationChannel channel,
      required FlutterLocalNotificationsPlugin
          flutterLocalNotificationsPlugin}) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

/* ------------------------------ ON INIT STATE ----------------------------- */

  static void foregroundNotitficationInit(
      {required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      required AndroidNotificationChannel channel}) {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification androidNotification =
            message.notification!.android!;
        if (notification != null && androidNotification != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(channel.id, channel.name,
                      channelDescription: channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/ic_launcher')));
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification androidNotification = message.notification!.android!;
      // if(notification!= null && androidNotification != null){

      // }
    });
  }
}
