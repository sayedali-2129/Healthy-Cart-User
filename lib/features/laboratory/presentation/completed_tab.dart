import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/completed_card.dart';
import 'package:provider/provider.dart';

class LabCompleted extends StatefulWidget {
  const LabCompleted({super.key});

  @override
  State<LabCompleted> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<LabCompleted> {
  final scrollController = ScrollController();
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    final ordersProvider = context.read<LabOrdersProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ordersProvider
          ..clearCompletedOrderData()
          ..getCompletedOrders(userId: authProvider.userFetchlDataFetched!.id!);
      },
    );
    ordersProvider.completedOrdersInit(
        scrollController: scrollController,
        userId: authProvider.userFetchlDataFetched!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      final screenWidth = MediaQuery.of(context).size.width;

      return CustomScrollView(
        controller: scrollController,
        slivers: [
          if (ordersProvider.isLoading == true &&
              ordersProvider.completedOrders.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.completedOrders.isEmpty)
            const ErrorOrNoDataPage(text: 'No Completed Tests Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.completedOrders.length,
                itemBuilder: (context, index) {
                  return FadeIn(
                    child: CompletedCard(
                      screenWidth: screenWidth,
                      index: index,
                    ),
                  );
                },
              ),
            ),
          SliverToBoxAdapter(
              child: (ordersProvider.isLoading == true &&
                      ordersProvider.completedOrders.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : const Gap(0)),
        ],
      );
    });
  }
}
