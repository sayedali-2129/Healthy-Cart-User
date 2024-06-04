import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ad_slider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_list_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/images/images.dart';
import 'package:provider/provider.dart';

class LabDetailsScreen extends StatelessWidget {
  const LabDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: BColors.mainlightColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8))),
          title: const Text(
            'Lab Name',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          shadowColor: BColors.black.withOpacity(0.8),
          elevation: 5,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 234,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                      image: AssetImage(BImage.labSample), fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Angel Laboratory',
                          style: TextStyle(
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
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Gap(5),
                        Expanded(
                          child: Text(
                            'Angel Hospitals - Kozhikode, Rose Dam, Near Police Station, Westham',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    const AdSlider(screenWidth: double.infinity),
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
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(8))),
                              child: const Center(
                                child: Text(
                                  'Lab Service',
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
                                  borderRadius: const BorderRadius.horizontal(
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
                    labProvider.isLabOnlySelected
                        ? SizedBox(
                            width: double.infinity,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Gap(5),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) => TestListCard(
                                image:
                                    'https://www.shutterstock.com/image-photo/young-scientists-conducting-research-investigations-260nw-2149947783.jpg',
                                testName: 'Blood Test',
                                testPrice: '500',
                                offerPrice: '400',
                                onAdd: () {},
                              ),
                            ),
                          )
                        /* ----------------------------- DOOR STEP TESTS ---------------------------- */
                        : SizedBox(
                            width: double.infinity,
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Gap(5),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) => TestListCard(
                                image:
                                    'https://thumbs.dreamstime.com/b/science-lab-chemicals-14262437.jpg',
                                testName: 'Sugar Test',
                                testPrice: '500',
                                offerPrice: '400',
                                onAdd: () {},
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
