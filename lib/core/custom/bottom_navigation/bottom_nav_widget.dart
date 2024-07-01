import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/home/application/provider/home_provider.dart';
import 'package:healthy_cart_user/features/home/presentation/home_main.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_main.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_main.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/pharmacy_main.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_main.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:provider/provider.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({
    super.key,
  });

  @override
  State<BottomNavigationWidget> createState() => _BottonNavTabState();
}

class _BottonNavTabState extends State<BottomNavigationWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void navigateToHospitalTab() {
    setState(() {
      _tabController.index = 1;
    });
  }

  void navigateToLaboratoryTab() {
    setState(() {
      _tabController.index = 2;
    });
  }

  void navigateToPharmacyTab() {
    setState(() {
      _tabController.index = 3;
    });
  }

  Future<void> navigateToLoginScreen() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    setState(() {
      _tabController.index = 0; // Return to the profile tab
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Consumer<HomeProvider>(builder: (context, provider, _) {
        return Scaffold(
          body: PopScope(
            canPop: provider.canPopNow,
            onPopInvoked: provider.onPopInvoked,
            child: TabBarView(
                controller: _tabController,
                clipBehavior: Clip.antiAlias,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeMain(
                    currentTab: _tabController.index,
                    onNavigateToHospitalTab: navigateToHospitalTab,
                    onNavigateToLaboratoryTab: navigateToLaboratoryTab,
                    onNavigateToPharmacyTab: navigateToPharmacyTab,
                  ),
                  const HospitalMain(),
                  const LabMain(),
                  const PharmacyMain(),
                  auth.currentUser != null
                      ? const ProfileMain()
                      : const LoginScreen()
                ]),
          ),
          bottomNavigationBar: PhysicalModel(
            color: Colors.white,
            elevation: 10,
            child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: UnderlineTabIndicator(
                  borderSide:
                      BorderSide(color: BColors.mainlightColor, width: 8.0),
                  insets: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 66.0),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat'),
                labelStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat'),
                labelColor: BColors.mainlightColor,
                unselectedLabelColor: BColors.black,
                onTap: (index) async {
                  if (index == 4 && auth.currentUser == null) {
                    await navigateToLoginScreen();
                  } else {
                    setState(() {
                      _tabController.index = index;
                    });
                  }
                },
                tabs: [
                  Tab(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _tabController.index == 0
                          ? Image.asset(
                              BIcon.homeColor,
                              height: 24,
                              width: 24,
                            )
                          : Image.asset(
                              BIcon.homeBlack,
                              height: 22,
                              width: 22,
                            ),
                    ),
                    text: 'Home',
                  ),
                  Tab(
                    text: 'Hospital',
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _tabController.index == 1
                          ? Image.asset(
                              BIcon.hospitalColor,
                              height: 24,
                              width: 24,
                            )
                          : Image.asset(
                              BIcon.hospitalBlack,
                              height: 22,
                              width: 22,
                            ),
                    ),
                  ),
                  Tab(
                    text: 'Lab',
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _tabController.index == 2
                          ? Image.asset(
                              BIcon.labColor,
                              height: 24,
                              width: 24,
                            )
                          : Image.asset(
                              BIcon.labBlack,
                              height: 22,
                              width: 22,
                            ),
                    ),
                  ),
                  Tab(
                    text: 'Medicine',
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _tabController.index == 3
                          ? Image.asset(
                              BIcon.medicineColor,
                              height: 24,
                              width: 24,
                            )
                          : Image.asset(
                              BIcon.medicineBlack,
                              height: 22,
                              width: 22,
                            ),
                    ),
                  ),
                  Tab(
                    text: 'Profile',
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: _tabController.index == 4
                          ? Image.asset(
                              BIcon.profileColor,
                              height: 26,
                              width: 26,
                            )
                          : Image.asset(
                              BIcon.profileBlack,
                              height: 24,
                              width: 24,
                            ),
                    ),
                  ),
                ]),
          ),
        );
      }),
    );
  }
}
