import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/di/injection.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/home/application/provider/home_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/notifications/application/provider/notification_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_profile_provider.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
import 'package:healthy_cart_user/utils/app_details.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependancy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<LabOrdersProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<HospitalProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<HomeProvider>(),
        ),
      ],
      child: MaterialApp(
        title: AppDetails.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: BColors.white, fontFamily: 'Montserrat'),
        home: const SplashScreen(),
      ),
    );
  }
}
