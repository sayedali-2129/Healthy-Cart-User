import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderRequestSuccessScreen extends StatefulWidget {
  const OrderRequestSuccessScreen({super.key});

  @override
  State<OrderRequestSuccessScreen> createState() =>
      _OrderRequestSuccessScreenState();
}

class _OrderRequestSuccessScreenState extends State<OrderRequestSuccessScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    final provider = context.read<LabProvider>();
    provider.playPaymentSound();
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                BLottie.paymentSuccess,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
              const Gap(16),
              const Text(
                'Your Laboratory appointment is currently being processed. We will notify you once its confirmed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            // labProvider.clearCart();
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const HomeScreen(),
            //   ),
            //   (route) => false,
            // );
          },
          child: Container(
            height: 60,
            color: BColors.mainlightColor,
            child: const Center(
              child: Text(
                'Done',
                style: TextStyle(
                  color: BColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
