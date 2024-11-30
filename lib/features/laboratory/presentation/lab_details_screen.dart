import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_tab_bar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/booking_date_time_lab.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_prescription_page.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ad_slider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_list_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_type_radio.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/presentation/profile_setup.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LabDetailsScreen extends StatefulWidget {
  const LabDetailsScreen({
    super.key,
  });

  @override
  State<LabDetailsScreen> createState() => _LabDetailsScreenState();
}

class _LabDetailsScreenState extends State<LabDetailsScreen> {
  @override
  void initState() {
    final labProvider = context.read<LabProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        labProvider.getAllTests(labId: labProvider.labId!);
        labProvider.getLabBanner(labId: labProvider.labId!);

        // await labProvider.getDoorStepOnly(labId: widget.labId);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer3<LabProvider, AuthenticationProvider, UserAddressProvider>(
        builder: (context, labProvider, authProvider, addressProvider, _) {
      final labList = labProvider.selectedLabData;

      return PopScope(
        onPopInvoked: (didPop) {
          labProvider.selectedTestIds.clear();
          labProvider.cartItems.clear();
          labProvider.isBottomContainerPopUp = false;
          labProvider.isLabOnlySelected = true;
          labProvider.selectedRadio = null;
        },
        child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverCustomAppbar(
                  title: labList?.laboratoryName ?? 'Labortary',
                  onBackTap: () {
                    EasyNavigation.pop(context: context);
                  },
                ),
                if (labProvider.detailsScreenLoading == true)
                  const SliverFillRemaining(
                      child: Center(child: LoadingIndicater()))
                else if (labProvider.detailsScreenLoading == false &&
                    labProvider.testList.isEmpty &&
                    labProvider.doorStepTestList.isEmpty &&
                    labProvider.labBannerList.isEmpty)
                  const SliverFillRemaining(
                      child: StillWorkingPage(
                    text:
                        "We are still working on our Laboratory, will be soon available.",
                  )),
                if (labProvider.labBannerList.isNotEmpty ||
                    labProvider.testList.isNotEmpty ||
                    labProvider.doorStepTestList.isNotEmpty)
                  SliverToBoxAdapter(
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        /* -------------------------------- LAB IMAGE ------------------------------- */
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: 234,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              CustomCachedNetworkImage(image: labList!.image!),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      BColors.black.withOpacity(0.5),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                /* -------------------------- LAB NAME AND ADDRESS -------------------------- */
                if (labProvider.labBannerList.isNotEmpty ||
                    labProvider.testList.isNotEmpty ||
                    labProvider.doorStepTestList.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FadeInDown(
                                  duration: const Duration(milliseconds: 500),
                                  child: Text(
                                    labList?.laboratoryName ?? 'No Name',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: BColors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 24,
                                ),
                                Expanded(
                                  child: Text(
                                    labList?.address ?? 'No Address',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FadeIn(
                              duration: const Duration(milliseconds: 500),
                              child: ButtonWidget(
                                buttonHeight: 36,
                                buttonWidth: 168,
                                buttonColor: BColors.buttonGreen,
                                buttonWidget: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.maps_ugc_outlined,
                                      color: BColors.black,
                                      size: 20,
                                    ),
                                    Text(
                                      'Prescription',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: BColors.black),
                                    )
                                  ],
                                ),
                                onPressed: () {
                                  if (authProvider.auth.currentUser == null) {
                                    EasyNavigation.push(
                                        type: PageTransitionType.rightToLeft,
                                        context: context,
                                        page: const LoginScreen());
                                    CustomToast.infoToast(
                                        text: 'Login to continue !');
                                  } else {
                                    if (authProvider
                                            .userFetchlDataFetched!.userName ==
                                        null) {
                                      EasyNavigation.push(
                                          context: context,
                                          page: const ProfileSetup());
                                    } else {
                                      labProvider.clearCurrentDetails();
                                      addressProvider.selectedAddress = null;
                                      EasyNavigation.push(
                                        context: context,
                                        page: LabPrescriptionPage(
                                          labModel: labList!,
                                        ),
                                        type: PageTransitionType.rightToLeft,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                        if (labProvider.labBannerList.isNotEmpty)
                          FadeInRight(
                            duration: const Duration(milliseconds: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: AdSlider(
                                screenWidth: double.infinity,
                                labId: labProvider.labId!,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: CustomTabBar(
                              screenWidth: screenWidth,
                              text1: 'All Tests',
                              text2: 'Door Step Tests',
                              tab1Color: labProvider.isLabOnlySelected
                                  ? BColors.mainlightColor
                                  : BColors.white,
                              tab2Color: labProvider.isLabOnlySelected
                                  ? BColors.white
                                  : BColors.mainlightColor,
                              onTapTab1: () =>
                                  labProvider.labTabSelection(true),
                              onTapTab2: () =>
                                  labProvider.labTabSelection(false),
                            ),
                          ),
                        ),

                        /* -------------------------------- ALL TESTS ------------------------------- */
                        labProvider.isLabOnlySelected
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: labProvider.testList.isEmpty
                                      ? const Center(
                                          child: Text('No Tests Available!'))
                                      : ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          separatorBuilder: (context, index) =>
                                              const Gap(6),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              labProvider.testList.length,
                                          itemBuilder: (context, index) {
                                            final testList =
                                                labProvider.testList[index];
                                            return FadeInUp(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: TestListCard(
                                                labTestModel: testList,
                                                isDoorstepAvailable: testList
                                                    .isDoorstepAvailable,
                                                index: index,
                                                image: testList.testImage!,
                                                testName: testList.testName ??
                                                    'No Name',
                                                testPrice:
                                                    testList.testPrice ?? 0,
                                                offerPrice: testList.offerPrice,
                                                isSelected: labProvider
                                                    .selectedTestIds
                                                    .contains(testList.id),
                                                onAdd: () {
                                                  labProvider.testAddButton(
                                                      testList.id!, testList);
                                                  labProvider
                                                      .bottomPopUpContainer();
                                                  if (labProvider
                                                      .isBottomContainerPopUp) {
                                                    bottomPopUp();
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              )
                            /* ----------------------------- DOOR STEP TESTS ---------------------------- */
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: labProvider.doorStepTestList.isEmpty
                                      ? const Center(
                                          child: Text('No Tests Available!'))
                                      : ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const Gap(6),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: labProvider
                                              .doorStepTestList.length,
                                          itemBuilder: (context, index) {
                                            final doorStepList = labProvider
                                                .doorStepTestList[index];
                                            return FadeInUp(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: TestListCard(
                                                doorStepTestModel: doorStepList,
                                                doorstepList: true,
                                                isDoorstepAvailable: true,
                                                index: index,
                                                image: doorStepList.testImage!,
                                                testName:
                                                    doorStepList.testName ??
                                                        'No Name',
                                                testPrice:
                                                    doorStepList.testPrice ?? 0,
                                                offerPrice:
                                                    doorStepList.offerPrice,
                                                isSelected: labProvider
                                                    .selectedTestIds
                                                    .contains(doorStepList.id),
                                                onAdd: () {
                                                  labProvider.testAddButton(
                                                      doorStepList.id!,
                                                      doorStepList);
                                                  if (labProvider
                                                      .selectedTestIds
                                                      .isNotEmpty) {
                                                    labProvider
                                                        .bottomPopUpContainer();
                                                    if (labProvider
                                                        .isBottomContainerPopUp) {
                                                      bottomPopUp();
                                                    }
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                      ],
                    ),
                  )
              ],
            ),
            bottomNavigationBar: labProvider.isBottomContainerPopUp
                ? bottomPopUp(
                    itemCount: labProvider.selectedTestIds.length,
                    onTap: () {
                      // final checkHomeAvailable = labProvider.cartItems
                      //     .any((item) => item.isDoorstepAvailable == false);
                      // if (checkHomeAvailable) {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => CheckoutScreen(
                      //           userId: authProvider.userFetchlDataFetched!.id!,
                      //           index: widget.index,
                      //         ),
                      //       ));
                      // } else {
                      if (authProvider.userFetchlDataFetched!.userName ==
                          null) {
                        EasyNavigation.push(
                            context: context, page: const ProfileSetup());
                        CustomToast.infoToast(text: 'Fill user details');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => TestTypeRadiopopup(
                            onConfirm: () {
                              final checkHomeAvailable = labProvider.cartItems
                                  .any((item) =>
                                      item.isDoorstepAvailable == false);
                              if (labProvider.selectedRadio == null) {
                                CustomToast.infoToast(
                                    text: 'Please select preferred test type');
                                return;
                              }
                              if (labProvider.selectedRadio == 'Home' &&
                                  checkHomeAvailable) {
                                CustomToast.errorToast(
                                    text:'One or more tests are not available for door step service');
                                    return;       
                              } 
                               
                                Navigator.pop(context);
                                EasyNavigation.push(
                                  type: PageTransitionType.rightToLeft,
                                  context: context,
                                  page: LabDateBookingScreen(
                                    user:authProvider.userFetchlDataFetched!,
                                    labModel: labProvider.selectedLabData!,
                                  
                                  ),
                                );
                            },
                          ),
                        );
                      }
                    },
                  )
                : null),
      );
    });
  }

  Widget bottomPopUp({int? itemCount, void Function()? onTap}) {
    return Animate(
            child: Container(
      height: 60,
      color: BColors.darkblue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$itemCount Test Selected',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: BColors.white),
            ),
            ButtonWidget(
                buttonHeight: 40,
                buttonWidth: 130,
                buttonColor: BColors.white,
                buttonWidget: const Text(
                  'Check Out',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.darkblue),
                ),
                onPressed: onTap)
          ],
        ),
      ),
    )).animate().slide(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
          duration: 200.milliseconds,
        );
  }
}
