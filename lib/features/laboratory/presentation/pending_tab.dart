import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/pending_card.dart';
import 'package:provider/provider.dart';

class LabPendingTab extends StatefulWidget {
  const LabPendingTab({super.key});

  @override
  State<LabPendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<LabPendingTab> {
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<LabOrdersProvider>()
            .getPendingOrders(userId: authProvider.userFetchlDataFetched!.id!);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      final screenWidth = MediaQuery.of(context).size.width;

      return CustomScrollView(
        slivers: [
          if (ordersProvider.isLoading == true &&
              ordersProvider.pendingOrders.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.pendingOrders.isEmpty)
            const ErrorOrNoDataPage(text: 'No Bookings Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.pendingOrders.length,
                itemBuilder: (context, index) {
                  return FadeIn(
                    child: PendingCard(
                      screenWidth: screenWidth,
                      index: index,
                    ),
                  );
                },
              ),
            )
        ],
      );
    });
  }
}
