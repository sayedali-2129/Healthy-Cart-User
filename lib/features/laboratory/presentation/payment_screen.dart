import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/payment_success_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/payment_type_radio.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/selected_tests_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LabPaymentScreen extends StatelessWidget {
  const LabPaymentScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(
      builder: (context, ordersProvider, _) {
        final orders = ordersProvider.ordersList[index];
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            backgroundColor: BColors.mainlightColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            title: const Text(
              'Payment',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            centerTitle: false,
            shadowColor: BColors.black.withOpacity(0.8),
            elevation: 5,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                      ),
                      const Gap(5),
                      Expanded(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${orders.labDetails!.laboratoryName}- ',
                                style: const TextStyle(
                                  color: BColors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              TextSpan(
                                text: '${orders.labDetails!.address}',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: BColors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  const Divider(),
                  const Gap(8),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemCount: orders.selectedTest!.length,
                      itemBuilder: (context, testIndex) {
                        return SelectedTestsCard(
                          testIndex: testIndex,
                          index: index,
                          testName: orders.selectedTest![testIndex].testName,
                          testPrice: orders.selectedTest![testIndex].testPrice
                              .toString(),
                          offerPrice: orders.selectedTest![testIndex].offerPrice
                              .toString(),
                          image:
                              orders.selectedTest![testIndex].testImage ?? '',
                        );
                      }),
                  const Gap(10),
                  OrderSummaryCardPayment(
                      isTimeSlotShow: orders.timeSlot == null ? false : true,
                      timeSlot: orders.timeSlot ?? '',
                      index: index,
                      totalTestFee: orders.totalAmount!,
                      doorStepCharge: orders.doorStepCharge!,
                      totalAmount: orders.finalAmount!),
                  const Gap(10),
                  ButtonWidget(
                      buttonHeight: 45,
                      buttonWidth: double.infinity,
                      buttonColor: const Color(0xff367CBD),
                      buttonWidget: const Text(
                        'Choose Payment Method',
                        style: TextStyle(
                            color: BColors.white, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => PaymentTypeRadio(
                                  onConfirm: () {
                                    // log(ordersProvider.paymentType ?? 'null');
                                    if (ordersProvider.paymentType ==
                                        'Doorstep Payment') {
                                      EasyNavigation.push(
                                          context: context,
                                          page: const PaymentSuccessScreen(),
                                          type: PageTransitionType.rightToLeft,
                                          duration: 200);
                                      // Navigator.pop(context);
                                      // ordersProvider.paymentType == null;
                                    } else {}
                                  },
                                ));
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ------------------------------ ORDER SUMMARY CARD----------------------------- */

class OrderSummaryCardPayment extends StatelessWidget {
  const OrderSummaryCardPayment({
    super.key,
    required this.totalTestFee,
    required this.doorStepCharge,
    required this.totalAmount,
    required this.index,
    required this.isTimeSlotShow,
    required this.timeSlot,
  });
  final num totalTestFee;
  final num doorStepCharge;
  final num totalAmount;
  final int index;
  final bool isTimeSlotShow;
  final String timeSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            isTimeSlotShow == false
                ? const Gap(0)
                : Column(
                    children: [
                      const Text(
                        'Time Scheduled',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: BColors.black),
                      ),
                      Text(
                        timeSlot,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: BColors.black),
                      ),
                    ],
                  ),
            const Gap(16),
            AmountRow(
              text: 'Total Test Fee',
              amountValue: '₹$totalTestFee',
            ),
            const Gap(8),
            Consumer<LabOrdersProvider>(builder: (context, value, _) {
              if (value.ordersList[index].testMode == 'Home') {
                return (value.ordersList[index].doorStepCharge == 0 ||
                        value.ordersList[index].doorStepCharge == null)
                    ? AmountRow(
                        text: 'Door Step Charge',
                        amountValue: 'Free Service',
                        amountColor: BColors.green,
                      )
                    : AmountRow(
                        text: 'Door Step Charge',
                        amountValue: '₹$doorStepCharge',
                      );
              } else {
                return const Gap(0);
              }
            }),
            const Gap(8),
            const Divider(),
            const Gap(8),
            AmountRow(
              text: 'Total Amount',
              amountValue: '₹$totalAmount',
              amountColor: BColors.black.withOpacity(0.7),
              textColor: BColors.black.withOpacity(0.7),
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class AmountRow extends StatelessWidget {
  const AmountRow(
      {super.key,
      required this.text,
      required this.amountValue,
      this.textColor = BColors.black,
      this.amountColor = BColors.black,
      this.fontSize = 15});
  final String text;
  final String amountValue;
  final Color? textColor;
  final Color? amountColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: textColor),
        ),
        Text(
          amountValue,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: amountColor),
        ),
      ],
    );
  }
}
