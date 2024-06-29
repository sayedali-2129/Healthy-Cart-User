import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hosp_pending_card.dart';
import 'package:provider/provider.dart';

class HospPending extends StatefulWidget {
  const HospPending({super.key});

  @override
  State<HospPending> createState() => _PendingTabState();
}

class _PendingTabState extends State<HospPending> {
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<HospitalBookingProivder>()
            .getPendingOrders(userId: authProvider.userFetchlDataFetched!.id!);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalBookingProivder>(
        builder: (context, ordersProvider, _) {
      final screenWidth = MediaQuery.of(context).size.width;

      return CustomScrollView(
        slivers: [
          if (ordersProvider.isLoading == true &&
              ordersProvider.pendingList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.pendingList.isEmpty)
            const ErrorOrNoDataPage(text: 'No Bookings Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.pendingList.length,
                itemBuilder: (context, index) {
                  return HospPendingCard(
                    screenWidth: screenWidth,
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
