import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/ad_slider_hospital.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class HospitalDetails extends StatefulWidget {
  const HospitalDetails(
      {super.key, required this.index, required this.hospitalId});
  final int index;
  final String hospitalId;

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<HospitalProvider>()
            .getHospitalBanner(hospitalId: widget.hospitalId);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      final hospital = hospitalProvider.hospitalList[widget.index];
      return Scaffold(
          body: CustomScrollView(slivers: [
        SliverCustomAppbar(
          title: hospital.hospitalName ?? 'Hospital',
          onBackTap: () {
            Navigator.pop(context);
          },
        ),
        hospitalProvider.isLoading == true
            ? const SliverFillRemaining(
                child: Center(child: LoadingIndicater()))
            : SliverToBoxAdapter(
                child: Column(
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        height: 234,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomCachedNetworkImage(image: hospital.image!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FadeInDown(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                hospital.hospitalName ?? 'No Name',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.black),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined),
                              const Gap(5),
                              Expanded(
                                child: Text(
                                  hospital.address ?? 'No Address',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        FadeInRight(
                          duration: const Duration(milliseconds: 500),
                          child: AdSliderHospital(
                            screenWidth: double.infinity,
                            labId: widget.hospitalId,
                          ),
                        ),
                        const Gap(8),
                      ]),
                    )
                  ],
                ),
              )
      ]));
    });
  }
}
