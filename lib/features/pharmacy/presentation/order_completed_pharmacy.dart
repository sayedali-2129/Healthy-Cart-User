import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/order_completed_card.dart';
import 'package:provider/provider.dart';

class PharmacyCompletedTab extends StatefulWidget {
  const PharmacyCompletedTab({super.key});

  @override
  State<PharmacyCompletedTab> createState() => _PharmacyCompletedTabState();
}

class _PharmacyCompletedTabState extends State<PharmacyCompletedTab> {
  final scrollController = ScrollController();
  final ScrollController _scrollcontroller = ScrollController();
  @override
  void initState() {
    final orderProvider = context.read<PharmacyOrderProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      orderProvider.clearCompletedOrderFetchData();
      orderProvider.getCompletedOrderDetails();
    });

    _scrollcontroller.addListener(() {
      if (_scrollcontroller.position.atEdge &&
          _scrollcontroller.position.pixels != 0 &&
          orderProvider.fetchLoading == false) {
        orderProvider.getCompletedOrderDetails();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyOrderProvider>(
        builder: (context, ordersProvider, _) {

      return CustomScrollView(
        controller: scrollController,
        slivers: [
          if (ordersProvider.fetchLoading == true &&
              ordersProvider.completedOrderList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.completedOrderList.isEmpty)
            const ErrorOrNoDataPage(text: 'No Completed Orders Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.completedOrderList.length,
                itemBuilder: (context, index) {
                  return PharmacyCompletedCard(
                      completedOrderData:ordersProvider.completedOrderList[index]);
                },
              ),
            ),
          SliverToBoxAdapter(
              child: (ordersProvider.fetchLoading == true &&
                      ordersProvider.completedOrderList.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : const Gap(0)),
        ],
      );
    });
  }
}
