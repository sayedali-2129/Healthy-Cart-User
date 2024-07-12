import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:healthy_cart_user/core/di/injection.dart';
import 'package:healthy_cart_user/core/services/foreground_notification.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/home/application/provider/home_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/notifications/application/provider/notification_provider.dart';
import 'package:healthy_cart_user/features/payment_gateway/application/gateway_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_profile_provider.dart';
import 'package:healthy_cart_user/features/splash_screen/dash_board_screen.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
import 'package:healthy_cart_user/utils/app_details.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Channel_id', 'channel_name',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await configureDependancy();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependancy();
  await ForegroundNotificationService.messageInit(
      channel: channel,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    ForegroundNotificationService.foregroundNotitficationInit(
        channel: channel,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // CustomToast(context: context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => sl<AuthenticationProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<LabProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<LocationProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<PharmacyProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<UserProfileProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<UserAddressProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<NotificationProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<LabOrdersProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<PharmacyOrderProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<HospitalProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<HomeProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<HospitalBookingProivder>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<GatewayProvider>(),
        ),
      ],
      child: GetMaterialApp(
          builder: (context, child) => Overlay(
                initialEntries: [
                  if (child != null) ...[
                    OverlayEntry(
                      builder: (context) => child,
                    ),
                  ],
                ],
              ),
          navigatorKey: navigatorKey,
          title: AppDetails.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: BColors.white, fontFamily: 'Montserrat'),
          home: Consumer<HomeProvider>(
              builder: (context, value, _) => FutureBuilder(
                  future: value.installedFirtTime(),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return const DashboardScreen();
                    } else {
                      return const SplashScreen();
                    }
                  }))),
    );
  }
}
