import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/features/home/presentation/home_main.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_main.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_main.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_main.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        bottomNavigationBar: BottomNavigationWidget(
      text1: 'Home',
      text2: 'Hospital',
      text3: 'Lab',
      text4: 'Medicine',
      text5: 'Profile',
      tabItems: [
        HomeMain(),
        HospitalMain(),
        LabMain(),
        PharmacyMain(),
        ProfileMain(),
      ],
    ));
  }
}
