import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/order_cancelled_card.dart';
import 'package:provider/provider.dart';

class PharmacyCancelledTab extends StatefulWidget {
  const PharmacyCancelledTab({super.key});

  @override
  State<PharmacyCancelledTab> createState() => _PharmacyCancelledTabState();
}

class _PharmacyCancelledTabState extends State<PharmacyCancelledTab> {
  final scrollController = ScrollController();
  final ScrollController _scrollcontroller = ScrollController();
  @override
  void initState() {
    final orderProvider = context.read<PharmacyOrderProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      orderProvider.clearCancelledOrderFetchData();
      orderProvider.getCancelledOrderDetails();
    });

    _scrollcontroller.addListener(() {
      if (_scrollcontroller.position.atEdge &&
          _scrollcontroller.position.pixels != 0 &&
          orderProvider.fetchLoading == false) {
        orderProvider.getCancelledOrderDetails();
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
              ordersProvider.cancelledOrderList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.cancelledOrderList.isEmpty)
            const ErrorOrNoDataPage(text: 'No Cancelled Orders Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.cancelledOrderList.length,
                itemBuilder: (context, index) {
                  return PharmacyCancelledCard(
                      cancelledOrderData:
                          ordersProvider.cancelledOrderList[index]);
                },
              ),
            ),
          SliverToBoxAdapter(
              child: (ordersProvider.fetchLoading == true &&
                      ordersProvider.cancelledOrderList.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : const Gap(0)),
        ],
      );
    });
  }
}
