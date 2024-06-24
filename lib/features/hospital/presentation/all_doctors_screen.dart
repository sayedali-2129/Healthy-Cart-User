import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/doctor_details_screen.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/doctor_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen(
      {super.key, required this.hospitalIndex, required this.hospitalId});
  final int hospitalIndex;
  final String hospitalId;

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    final hospitalProvider = context.read<HospitalProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        hospitalProvider.doctorinit(
            scrollController: scrollController, hospitalId: widget.hospitalId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
              title: 'All Doctors',
              onBackTap: () {
                Navigator.pop(context);
              },
              child: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      EasyDebounce.debounce(
                        'doctorSearch',
                        Duration(microseconds: 500),
                        () {
                          hospitalProvider.searchDoctor(
                              hospitalId: widget.hospitalId);
                        },
                      );
                    },
                    showCursor: false,
                    cursorColor: BColors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                      hintText: 'Search Doctor',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: const Icon(
                        Icons.search_outlined,
                        color: BColors.darkblue,
                      ),
                      filled: true,
                      fillColor: BColors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, doctorIndex) => Gap(10),
                itemCount: hospitalProvider.doctorsList.length,
                itemBuilder: (context, doctorIndex) => GestureDetector(
                  onTap: () {
                    EasyNavigation.push(
                        context: context,
                        page: DoctorDetailsScreen(
                          hospitalIndex: widget.hospitalIndex,
                          doctorIndex: doctorIndex,
                          hospitalAddress: hospitalProvider
                              .hospitalList[widget.hospitalIndex].address!,
                        ),
                        type: PageTransitionType.rightToLeft,
                        duration: 250);
                  },
                  child: DoctorCard(index: doctorIndex),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
