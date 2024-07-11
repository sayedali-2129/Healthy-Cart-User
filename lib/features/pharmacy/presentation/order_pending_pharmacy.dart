import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/order_pending_card.dart';
import 'package:provider/provider.dart';

class PharmacyPendingTab extends StatefulWidget {
  const PharmacyPendingTab({super.key});

  @override
  State<PharmacyPendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<PharmacyPendingTab> {
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final orderProvider = context.read<PharmacyOrderProvider>();
        orderProvider.setUserId(authProvider.userFetchlDataFetched?.id ?? '');
        orderProvider.getPendingOrders();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyOrderProvider>(
        builder: (context, ordersProvider, _) {
      return CustomScrollView(
        slivers: [
          if (ordersProvider.fetchLoading == true &&
              ordersProvider.pendingOrders.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.pendingOrders.isEmpty)
            const ErrorOrNoDataPage(text: 'No pending orders found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.pendingOrders.length,
                itemBuilder: (context, index) {
                  return PharmacyPendingCard(
                    pendingorderData: ordersProvider.pendingOrders[index],
                    index: index,
                  );
                },
              ),
            )
        ],
      );
    });
  }
}
