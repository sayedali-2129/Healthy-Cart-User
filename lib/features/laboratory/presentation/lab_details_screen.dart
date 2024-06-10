import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/checkout_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ad_slider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_list_card.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_type_radio.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class LabDetailsScreen extends StatefulWidget {
  const LabDetailsScreen({super.key, required this.index, required this.labId});
  final int index;
  final String labId;

  @override
  State<LabDetailsScreen> createState() => _LabDetailsScreenState();
}

class _LabDetailsScreenState extends State<LabDetailsScreen> {
  @override
  void initState() {
    final labProvider = context.read<LabProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        labProvider.getAllTests(labId: widget.labId);
        // await labProvider.getDoorStepOnly(labId: widget.labId);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<LabProvider, AuthenticationProvider>(
        builder: (context, labProvider, authProvider, _) {
      final labList = labProvider.labList[widget.index];

      return PopScope(
        onPopInvoked: (didPop) {
          labProvider.selectedTestIds.clear();
          labProvider.cartItems.clear();
          labProvider.isBottomContainerPopUp = false;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              backgroundColor: BColors.mainlightColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              title: Text(
                labList.laboratoryName ?? 'No Name',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              shadowColor: BColors.black.withOpacity(0.8),
              elevation: 5,
            ),
            body: labProvider.detailsScreenLoading == true
                ? const Center(child: LoadingIndicater())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 234,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              CustomCachedNetworkImage(image: labList.image!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    labList.laboratoryName ?? 'No Name',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: BColors.black),
                                  ),
                                  /* --------------------------- Prescription Button -------------------------- */
                                  ButtonWidget(
                                    buttonHeight: 36,
                                    buttonWidth: 160,
                                    buttonColor: BColors.buttonGreen,
                                    buttonWidget: const Row(
                                      children: [
                                        Icon(
                                          Icons.maps_ugc_outlined,
                                          color: BColors.black,
                                          size: 19,
                                        ),
                                        Gap(5),
                                        Text(
                                          'Prescription',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: BColors.black),
                                        )
                                      ],
                                    ),
                                    onPressed: () {},
                                  )
                                  /* -------------------------------------------------------------------------- */
                                ],
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const Gap(5),
                                  Expanded(
                                    child: Text(
                                      labList.address ?? 'No Address',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              AdSlider(
                                screenWidth: double.infinity,
                                labId: widget.labId,
                              ),
                              const Gap(8),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        labProvider.labTabSelection();
                                      },
                                      child: Container(
                                        width: screenWidth / 2,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: labProvider.isLabOnlySelected
                                                ? BColors.mainlightColor
                                                : BColors.white,
                                            border: Border.all(width: 0.5),
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    left: Radius.circular(8))),
                                        child: const Center(
                                          child: Text(
                                            'All',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        labProvider.labTabSelection();
                                      },
                                      child: Container(
                                        width: screenWidth / 2,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: labProvider.isLabOnlySelected
                                                ? BColors.white
                                                : BColors.mainlightColor,
                                            border: Border.all(width: 0.5),
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    right: Radius.circular(8))),
                                        child: const Center(
                                          child: Text(
                                            'Door Step',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              /* -------------------------------- ALL TESTS ------------------------------- */
                              labProvider.isLabOnlySelected
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: labProvider.testList.isEmpty
                                          ? const Center(
                                              child:
                                                  Text('No Tests Available!'))
                                          : ListView.separated(
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Gap(5),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  labProvider.testList.length,
                                              itemBuilder: (context, index) {
                                                final testList =
                                                    labProvider.testList[index];
                                                return TestListCard(
                                                  isDoorstepAvailable: testList
                                                      .isDoorstepAvailable,
                                                  index: index,
                                                  image: testList.testImage!,
                                                  testName: testList.testName ??
                                                      'No Name',
                                                  testPrice:
                                                      '${testList.testPrice ?? 000}',
                                                  offerPrice:
                                                      '${testList.offerPrice}',
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
                                                );
                                              },
                                            ),
                                    )
                                  /* ----------------------------- DOOR STEP TESTS ---------------------------- */
                                  : SizedBox(
                                      width: double.infinity,
                                      child: labProvider
                                              .doorStepTestList.isEmpty
                                          ? const Center(
                                              child:
                                                  Text('No Tests Available!'))
                                          : ListView.separated(
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Gap(5),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: labProvider
                                                  .doorStepTestList.length,
                                              itemBuilder: (context, index) {
                                                final doorStepList = labProvider
                                                    .doorStepTestList[index];
                                                return TestListCard(
                                                  doorstepList: true,
                                                  isDoorstepAvailable: true,
                                                  index: index,
                                                  image:
                                                      doorStepList.testImage!,
                                                  testName:
                                                      doorStepList.testName ??
                                                          'No Name',
                                                  testPrice:
                                                      '${doorStepList.testPrice ?? 000}',
                                                  offerPrice:
                                                      '${doorStepList.offerPrice}',
                                                  isSelected: labProvider
                                                      .selectedTestIds
                                                      .contains(
                                                          doorStepList.id),
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
                                                );
                                              },
                                            ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
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
                      showDialog(
                        context: context,
                        builder: (context) => TestTypeRadiopopup(
                          onConfirm: () {
                            final checkHomeAvailable = labProvider.cartItems
                                .any((item) =>
                                    item.isDoorstepAvailable == false);
                            if (labProvider.selectedRadio == null) {
                              CustomToast.errorToast(
                                  text: 'Please select preferred test type');
                            } else if (labProvider.selectedRadio == 'Home' &&
                                checkHomeAvailable) {
                              CustomToast.errorToast(
                                  text:
                                      'One or more tests are not available for door step service');
                            } else {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      userId: authProvider
                                          .userFetchlDataFetched!.id!,
                                      index: widget.index,
                                    ),
                                  ));
                              // labProvider.selectedRadio = null;
                            }
                          },
                        ),
                      );
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
