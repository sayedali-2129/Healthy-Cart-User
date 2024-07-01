import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_details_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_orders_tab.dart';
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
  final scrollController = ScrollController();
  @override
  void initState() {
    final labProvider = context.read<LabProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        labProvider
          ..clearLabData()
          ..getLabs();
      },
    );
    labProvider.init(scrollController);
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('labsearch');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final locationProvider = context.read<LocationProvider>();
    return Consumer3<LabProvider, LabOrdersProvider, AuthenticationProvider>(
        builder: (context, labProvider, labOrders, authProvider, _) {
      final screenwidth = MediaQuery.of(context).size.width;
      return Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            HomeSliverAppbar(
              searchHint: 'Search Laboratory',
              searchController: labProvider.labSearchController,
              onChanged: (_) {
                EasyDebounce.debounce(
                  'labsearch',
                  const Duration(milliseconds: 500),
                  () {
                    labProvider.searchLabs();
                  },
                );
              },  locationText: "${locationProvider.localsavedplacemark?.localArea},${locationProvider.localsavedplacemark?.district},${locationProvider.localsavedplacemark?.state}",
               locationTap: () {
                  LoadingLottie.showLoading(
                      context: context, text: 'Please wait...');
                  locationProvider.getLocationPermisson().then(
                    (value) {
                      if (value == true) {
                        EasyNavigation.pop(context: context);
                        EasyNavigation.push(
                            context: context,
                            page: const UserLocationSearchWidget(
                              isUserEditProfile: true,
                            ));
                      }
                    },
                  );
                },
            ),
            if (labProvider.labFetchLoading == true &&
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
                padding: const EdgeInsets.all(16),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(8),
                  itemCount: labProvider.labList.length,
                  itemBuilder: (context, index) => FadeInUp(
                    child: LabListCard(
                      screenwidth: screenwidth,
                      index: index,
                      onTap: () {
                        if (authProvider.auth.currentUser == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                          CustomToast.infoToast(text: 'Login to continue !');
                        } else {
                          EasyNavigation.push(
                            context: context,
                            type: PageTransitionType.rightToLeft,
                            duration: 300,
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
                child: (labProvider.labFetchLoading == true &&
                        labProvider.labList.isNotEmpty)
                    ? const Center(child: LoadingIndicater())
                    : const Gap(0)),
          ],
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
                            duration: 200);
                      }),
                  if (labOrders.approvedOrders
                      .any((element) => element.isUserAccepted == false))
                    const Positioned(
                      right: 2,
                      top: 2,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.yellow,
                      ),
                    )
                  else
                    const Gap(0),
                ],
              ),
      );
    });
  }
}
