import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hosp_cancelled_card.dart';
import 'package:provider/provider.dart';

class HospCancelled extends StatefulWidget {
  const HospCancelled({super.key});

  @override
  State<HospCancelled> createState() => _CancelledTabState();
}

class _CancelledTabState extends State<HospCancelled> {
  final scrollController = ScrollController();
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    final ordersProvider = context.read<HospitalBookingProivder>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ordersProvider
          ..clearCancelledData()
          ..getCancelledOrders(userId: authProvider.userFetchlDataFetched!.id!);
      },
    );
    ordersProvider.cancelledInit(
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
              ordersProvider.cancelledHospBooking.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.cancelledHospBooking.isEmpty)
            const ErrorOrNoDataPage(text: 'No Cancelled Bookings Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.cancelledHospBooking.length,
                itemBuilder: (context, index) {
                  return FadeIn(
                    child: HospCancelledCard(
                      screenWidth: screenWidth,
                      index: index,
                    ),
                  );
                },
              ),
            ),
          SliverToBoxAdapter(
              child: (ordersProvider.isLoading == true &&
                      ordersProvider.cancelledHospBooking.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : const Gap(0)),
        ],
      );
    });
  }
}
