import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_details.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hospital_main_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalMain extends StatefulWidget {
  const HospitalMain({super.key});

  @override
  State<HospitalMain> createState() => _HospitalMainState();
}

class _HospitalMainState extends State<HospitalMain> {
  final scrollController = ScrollController();

  @override
  void initState() {
    final hospitalProvider = context.read<HospitalProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        hospitalProvider
          ..clearHospitalData()
          ..getAllHospitals();
      },
    );
    hospitalProvider.hospitalInit(scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer<HospitalProvider>(builder: (context, hospitalProvider, _) {
      return Scaffold(
          body: CustomScrollView(
        controller: scrollController,
        slivers: [
          HomeSliverAppbar(
            searchHint: 'Search Hospitals',
            searchController: hospitalProvider.hospitalSearch,
            onChanged: (_) {
              EasyDebounce.debounce(
                'hospitalsearch',
                const Duration(milliseconds: 500),
                () {
                  hospitalProvider.searchHospitals();
                },
              );
            },
          ),
          if (hospitalProvider.hospitalFetchLoading == true &&
              hospitalProvider.hospitalList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (hospitalProvider.hospitalList.isEmpty)
            const SliverFillRemaining(
              child: NoDataImageWidget(text: 'No Hospitals Found'),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(8),
                itemCount: hospitalProvider.hospitalList.length,
                itemBuilder: (context, index) => HospitalMainCard(
                  screenwidth: screenwidth,
                  index: index,
                  onTap: () {
                    EasyNavigation.push(
                        context: context,
                        type: PageTransitionType.rightToLeft,
                        duration: 250,
                        page: HospitalDetails(
                          hospitalId: hospitalProvider.hospitalList[index].id!,
                          categoryIdList: hospitalProvider
                                  .hospitalList[index].selectedCategoryId ??
                              [],
                          hospitalIndex: index,
                        ));
                  },
                ),
              ),
            )
        ],
      ));
    });
  }
}
