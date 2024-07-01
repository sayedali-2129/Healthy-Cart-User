import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/hosp_accept_card.dart';
import 'package:provider/provider.dart';

class HospAccepted extends StatefulWidget {
  const HospAccepted({super.key});

  @override
  State<HospAccepted> createState() => _AcceptedTabState();
}

class _AcceptedTabState extends State<HospAccepted> {
  @override
  void initState() {
    final authProvider = context.read<AuthenticationProvider>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<HospitalBookingProivder>()
            .getAcceptedOrders(userId: authProvider.userFetchlDataFetched!.id!);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<HospitalBookingProivder>(
        builder: (context, ordersProvider, _) {
      return CustomScrollView(
        slivers: [
          if (ordersProvider.isLoading == true &&
              ordersProvider.approvedBookings.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: LoadingIndicater(),
              ),
            )
          else if (ordersProvider.approvedBookings.isEmpty)
            const ErrorOrNoDataPage(text: 'No Bookings Found!')
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(12),
                  itemCount: ordersProvider.approvedBookings.length,
                  itemBuilder: (context, index) {
                    return FadeIn(
                      child: HospAcceptCard(
                        screenWidth: screenWidth,
                        hospitalBookingModel:
                            ordersProvider.approvedBookings[index],
                      ),
                    );
                  }),
            )
        ],
      );
    });
  }
}
