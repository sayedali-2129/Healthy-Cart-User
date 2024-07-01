import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hosp_completed_card.dart';
import 'package:provider/provider.dart';

class HospCompleted extends StatefulWidget {
  const HospCompleted({super.key});

  @override
  State<HospCompleted> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<HospCompleted> {
  final scrollController = ScrollController();
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    final ordersProvider = context.read<HospitalBookingProivder>();
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
    return Consumer<HospitalBookingProivder>(
        builder: (context, ordersProvider, _) {
      final screenWidth = MediaQuery.of(context).size.width;

      return CustomScrollView(
        controller: scrollController,
        slivers: [
          if (ordersProvider.isLoading == true &&
              ordersProvider.completedBookings.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.completedBookings.isEmpty)
            const ErrorOrNoDataPage(text: 'No Completed Bookings Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.completedBookings.length,
                itemBuilder: (context, index) {
                  return FadeIn(
                      child: HospitalCompletedCard(
                          completedOrderData:
                              ordersProvider.completedBookings[index]));
                },
              ),
            ),
          SliverToBoxAdapter(
              child: (ordersProvider.isLoading == true &&
                      ordersProvider.completedBookings.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : const Gap(0)),
        ],
      );
    });
  }
}
