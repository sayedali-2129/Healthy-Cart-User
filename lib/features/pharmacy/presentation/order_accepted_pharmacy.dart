import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/order_accept_card.dart';
import 'package:provider/provider.dart';

class PharmacyAcceptedTab extends StatefulWidget {
  const PharmacyAcceptedTab({super.key});

  @override
  State<PharmacyAcceptedTab> createState() => _PharmacyAcceptedTabState();
}

class _PharmacyAcceptedTabState extends State<PharmacyAcceptedTab> {
  @override
  void initState() {
    final orderProvider = context.read<PharmacyOrderProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        orderProvider.getpharmacyApprovedOrderData();
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
              ordersProvider.approvedOrderList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.approvedOrderList.isEmpty)
            const ErrorOrNoDataPage(text: 'No Approved Orders Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(12),
                  itemCount: ordersProvider.approvedOrderList.length,
                  itemBuilder: (context, index) {
                    return PharmacyAcceptedCard(
                        onProcessOrderData:
                            ordersProvider.approvedOrderList[index]);
                  }),
            )
        ],
      );
    });
  }
}
