import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/home_sliver_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_details_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_list_card.dart';
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
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      return Scaffold(
          body: CustomScrollView(
        controller: scrollController,
        slivers: [
          HomeSliverAppbar(
            searchHint: 'Search Pharmacy',
            searchController: labProvider.labSearchController,
            onChanged: (_) {
              labProvider.searchLabs();
            },
          ),
          if (labProvider.labFetchLoading == true &&
              labProvider.labList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(8),
                itemCount: labProvider.labList.length,
                itemBuilder: (context, index) => LabListCard(
                    index: index,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LabDetailsScreen(),
                        ))),
              ),
            )
        ],
      ));
    });
  }
}
