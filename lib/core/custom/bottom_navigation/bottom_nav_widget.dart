import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.tabItems,
  });
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;

  final List<Widget> tabItems;
  @override
  State<BottomNavigationWidget> createState() => _BottonNavTabState();
}

class _BottonNavTabState extends State<BottomNavigationWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
            clipBehavior: Clip.antiAlias,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.tabItems),
        bottomNavigationBar: PhysicalModel(
          color: Colors.white,
          elevation: 10,
          child: TabBar(
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
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat'),
              labelColor: BColors.mainlightColor,
              unselectedLabelColor: BColors.black,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              tabs: [
                Tab(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: selectedIndex == 0
                        ? Image.asset(
                            BIcon.homeColor,
                            height: 22,
                            width: 22,
                          )
                        : Image.asset(
                            BIcon.homeBlack,
                            height: 22,
                            width: 22,
                          ),
                  ),
                  text: widget.text1,
                ),
                Tab(
                  text: widget.text2,
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: selectedIndex == 1
                        ? Image.asset(
                            BIcon.hospitalColor,
                            height: 22,
                            width: 22,
                          )
                        : Image.asset(
                            BIcon.hospitalBlack,
                            height: 22,
                            width: 22,
                          ),
                  ),
                ),
                Tab(
                  text: widget.text3,
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: selectedIndex == 2
                        ? Image.asset(
                            BIcon.labColor,
                            height: 22,
                            width: 22,
                          )
                        : Image.asset(
                            BIcon.labBlack,
                            height: 22,
                            width: 22,
                          ),
                  ),
                ),
                Tab(
                  text: widget.text4,
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: selectedIndex == 3
                        ? Image.asset(
                            BIcon.medicineColor,
                            height: 22,
                            width: 22,
                          )
                        : Image.asset(
                            BIcon.medicineBlack,
                            height: 22,
                            width: 22,
                          ),
                  ),
                ),
                Tab(
                  text: widget.text5,
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: selectedIndex == 4
                        ? Image.asset(
                            BIcon.profileColor,
                            height: 24,
                            width: 24,
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
      ),
    );
  }
}
