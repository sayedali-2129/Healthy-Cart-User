import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/location_no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_details_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_orders_tab.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_search_main.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_list_card.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/application/location_provider.dart';
import 'package:healthy_cart_user/features/location_picker/location_picker/presentation/location_search.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/icons/icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LabMain extends StatefulWidget {
  const LabMain({super.key});

  @override
  State<LabMain> createState() => _LabMainState();
}

class _LabMainState extends State<LabMain> {
  @override
  void initState() {
    final labProvider = context.read<LabProvider>();
    final labOrderProvider = context.read<LabOrdersProvider>();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        labProvider
          ..clearLabData()
          ..labortaryFetchInitData(context: context);
        if (userId != null) {
          labOrderProvider.getSingleOrderDoc(userId: userId);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<LabProvider, LabOrdersProvider, AuthenticationProvider,
            LocationProvider>(
        builder: (context, labProvider, labOrders, authProvider,
            locationProvider, _) {
      final screenwidth = MediaQuery.of(context).size.width;
      return Scaffold(
        body: RefreshIndicator(
          color: BColors.darkblue,
          backgroundColor: BColors.white,
          onRefresh: () async {
            labProvider
              ..clearLabortaryLocationData()
              ..labortaryFetchInitData(context: context);
          },
          child: CustomScrollView(
            controller: labProvider.mainScrollController,
            slivers: [
              HomeSliverAppbar(
                onSearchTap: () {
                  EasyNavigation.push(
                      type: PageTransitionType.topToBottom,
                      context: context,
                      page: const LaboratoriesMainSearch());
                },
                searchHint: 'Search Laboratories',
                locationText:
                    "${locationProvider.locallySavedLabortaryplacemark?.localArea},${locationProvider.locallySavedLabortaryplacemark?.district},${locationProvider.locallySavedLabortaryplacemark?.state}",
                locationTap: () {
                  EasyNavigation.push(
                    type: PageTransitionType.topToBottom,
                    context: context,
                    page: UserLocationSearchWidget(
                      isUserEditProfile: false,
                      locationSetter: 2,
                      onSucess: () {
                        labProvider.labortaryFetchInitData(context: context);
                      },
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                  child: (labProvider.labList.isNotEmpty &&
                          labProvider.checkNearestLabortaryLocation())
                      ? NoDataInSelectedLocation(
                          locationTitle:
                              '${locationProvider.locallySavedLabortaryplacemark?.localArea}',
                          typeOfService: 'labortaries',
                        )
                      : null),
              if (labProvider.isFirebaseDataLoding == true &&
                  labProvider.labList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (labProvider.labList.isEmpty)
                const ErrorOrNoDataPage(text: 'No Laboratories Found')
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverList.separated(
                    separatorBuilder: (context, index) => const Gap(12),
                    itemCount: labProvider.labList.length,
                    itemBuilder: (context, index) => FadeInUp(
                      child: LabListCard(
                        screenwidth: screenwidth,
                        labortaryData: labProvider.labList[index],
                        onTap: () {
                          if (authProvider.auth.currentUser == null) {
                            EasyNavigation.push(
                                type: PageTransitionType.rightToLeft,
                                context: context,
                                page: const LoginScreen());

                            CustomToast.infoToast(text: 'Login to continue !');
                          } else {
                            EasyNavigation.push(
                              context: context,
                              type: PageTransitionType.rightToLeft,
                              page: LabDetailsScreen(
                                index: index,
                                labId: labProvider.labList[index].id!,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                  child: (labProvider.circularProgressLOading == true &&
                          labProvider.labList.isNotEmpty)
                      ? const Center(child: LoadingIndicater())
                      : null),
            ],
          ),
        ),
        floatingActionButton: authProvider.auth.currentUser == null
            ? null
            : Stack(
                children: [
                  FloatingActionButton(
                      backgroundColor: BColors.darkblue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Image.asset(
                        color: BColors.white,
                        BIcon.calenderIcon,
                        scale: 3.2,
                      ),
                      onPressed: () {
                        EasyNavigation.push(
                          context: context,
                          page: const LabOrdersTab(),
                          type: PageTransitionType.bottomToTop,
                        );
                      }),
                  if (labOrders.singleOrderDoc != null)
                    const Positioned(
                      right: 2,
                      top: 2,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.yellow,
                      ),
                    )
                ],
              ),
      );
    });
  }
}
