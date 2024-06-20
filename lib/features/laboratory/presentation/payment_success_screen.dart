import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key, required this.index});
  final int index;

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Thank You',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              LottieBuilder.asset(
                BLottie.bookingSuccess,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              const Text(
                'Your Booking Successfully Completed',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const Gap(20),
              const Text(
                'Booking ID',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Gap(5),
              // Text(
              //   ordersProvider.approvedOrders[widget.index].id!,
              //   style:
              //       const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              // ),
              const Gap(25),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ButtonWidget(
                  buttonHeight: 42,
                  buttonWidth: double.infinity,
                  buttonColor: BColors.mainlightColor,
                  buttonWidget: const Text(
                    'Back To Home Page',
                    style: TextStyle(color: BColors.white),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationWidget(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
