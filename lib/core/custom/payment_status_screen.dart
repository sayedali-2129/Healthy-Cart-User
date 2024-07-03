import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/razorpay_service.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:healthy_cart_user/utils/constants/lottie/lotties.dart';
import 'package:lottie/lottie.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen(
      {super.key, this.bookingId, required this.isErrorPage, this.reason});
  final String? bookingId;
  final String? reason;
  final bool isErrorPage;

  @override
  State<PaymentStatusScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentStatusScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  RazorpayService razorpayService = RazorpayService();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.isErrorPage == false ? 'Thank You' : 'Booking Failed!',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              widget.isErrorPage == false
                  ? LottieBuilder.asset(
                      BLottie.bookingSuccess,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    )
                  : LottieBuilder.asset(
                      BLottie.paymentFailed,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
              Text(
                widget.isErrorPage == false
                    ? 'Your Booking Successfully Completed!!'
                    : 'Your Booking is Failed!!',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Gap(20),
              Text(
                widget.isErrorPage == false ? 'Booking ID :' : 'Reason :',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Gap(5),
              Text(
                widget.isErrorPage == false
                    ? widget.bookingId ?? 'Not Found'
                    : widget.reason ?? 'Not Found',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Gap(25),
              widget.isErrorPage == true
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ButtonWidget(
                        buttonHeight: 42,
                        buttonWidth: double.infinity,
                        buttonColor: BColors.mainlightColor,
                        buttonWidget: const Text(
                          'Back to checkout',
                          style: TextStyle(color: BColors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ButtonWidget(
                        buttonHeight: 42,
                        buttonWidth: double.infinity,
                        buttonColor: BColors.mainlightColor,
                        buttonWidget: const Text(
                          'Go To Home',
                          style: TextStyle(color: BColors.white),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationWidget(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
              const Gap(30),
              widget.isErrorPage == true
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavigationWidget(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go To Home',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: BColors.black,
                          )
                        ],
                      ),
                    )
                  : const Gap(0)
            ],
          ),
        ),
      ),
    );
  }
}
