import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_details_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_orders_tab.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_list_card.dart';
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
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
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
                    itemBuilder: (context, index) => LabListCard(
                      index: index,
                      onTap: () => EasyNavigation.push(
                        context: context,
                        type: PageTransitionType.rightToLeft,
                        duration: 300,
                        page: LabDetailsScreen(
                          index: index,
                          labId: labProvider.labList[index].id!,
                        ),
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
          floatingActionButton: FloatingActionButton(
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
              );
    });
  }
}
