// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/launch_dialer.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/core/services/razorpay_service.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/patient_details_card.dart';
import 'package:healthy_cart_user/features/hospital/presentation/widgets/payment_radio_hosp.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospitalPaymentScreen extends StatefulWidget {
  const HospitalPaymentScreen({super.key, required this.bookingModel});
  final HospitalBookingModel bookingModel;

  @override
  State<HospitalPaymentScreen> createState() => _HospitalPaymentScreenState();
}

class _HospitalPaymentScreenState extends State<HospitalPaymentScreen> {
  RazorpayService razorpayService = RazorpayService();

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalBookingProivder>(
      builder: (context, ordersProvider, _) {
        // final bookingModel = ordersProvider.approvedOrders[index];
        return PopScope(
          onPopInvoked: (didPop) {
            ordersProvider.hospitalpPaymentType = null;
          },
          child: Scaffold(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 70,
                            width: 70,
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: CustomCachedNetworkImage(
                                image: widget
                                    .bookingModel.hospitalDetails!.image!)),
                        const Gap(20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${widget.bookingModel.selectedDoctor!.doctorName} (${widget.bookingModel.selectedDoctor!.doctorQualification})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              Text(
                                '(${widget.bookingModel.selectedDoctor!.doctorSpecialization!})',
                                style:const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: BColors.grey),
                              ),
                              const Gap(5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                    ),
                                  ),
                                  // const Gap(5),
                                  Expanded(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${widget.bookingModel.hospitalDetails!.hospitalName} ',
                                              style: const TextStyle(
                                                color: BColors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                fontFamily: 'Montserrat',
                                              )),
                                          TextSpan(
                                            text: widget.bookingModel
                                                .hospitalDetails!.address,
                                            style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: BColors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Gap(8),
                    const Divider(),
                    PatientDetailsContainer(
                        patientName: widget.bookingModel.patientName ?? '',
                        patientGender: widget.bookingModel.patientGender ?? '',
                        patientNumber: widget.bookingModel.patientNumber ?? '',
                        patientAge: widget.bookingModel.patientAge ?? '',
                        patientPlace: widget.bookingModel.patientPlace ?? ''),
                    const Gap(8),
                    OrderSummaryCardPaymentHosp(
                        timeSlot:
                            '${widget.bookingModel.newBookingDate ?? widget.bookingModel.selectedDate} : ${widget.bookingModel.newTimeSlot ?? widget.bookingModel.selectedTimeSlot}',
                        totalAmount: widget.bookingModel.totalAmount!),
                    const Gap(10),
                    ButtonWidget(
                        buttonHeight: 45,
                        buttonWidth: double.infinity,
                        buttonColor: const Color(0xff367CBD),
                        buttonWidget: const Text(
                          'Choose Payment Method',
                          style: TextStyle(
                              color: BColors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => PaymentTypeRadioHospital(
                                    onConfirm: () async {
                                      log(ordersProvider.hospitalpPaymentType ??
                                          'null');
                                      if (ordersProvider.hospitalpPaymentType ==
                                          null) {
                                        CustomToast.infoToast(
                                            text:
                                                'Select preffered payment method');
                                        return;
                                      } else {
                                        LoadingLottie.showLoading(
                                            context: context,
                                            text: 'Loading...');
                                        if (ordersProvider
                                                .hospitalpPaymentType ==
                                            'Cash in hand') {
                                          await ordersProvider.acceptOrder(
                                              userName: widget.bookingModel
                                                  .userDetails!.userName!,
                                              fcmtoken: widget.bookingModel
                                                  .hospitalDetails!.fcmToken!,
                                              orderId: widget.bookingModel.id!);

                                          await EasyNavigation.push(
                                            
                                              context: context,
                                              page: const OrderRequestSuccessScreen(
                                                  title:
                                                      'Your Booking is successfully completed!'),
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              duration: 200);
                                          ordersProvider.hospitalpPaymentType ==
                                              null;

                                          Navigator.pop(context);
                                        } else {
                                          razorpayService.openRazorpay(
                                            amount: widget
                                                .bookingModel.totalAmount!,
                                            key: 'rzp_test_ky3Rg3L4nSwYE1',
                                            orgName: 'Healthy Cart',
                                            userPhoneNumber: widget.bookingModel
                                                .userDetails!.phoneNo!,
                                            userEmail: widget.bookingModel
                                                .userDetails!.userEmail!,
                                            onSuccess: (paymentId) async {
                                              await ordersProvider.acceptOrder(
                                                  userName: widget.bookingModel
                                                      .userDetails!.userName!,
                                                  fcmtoken: widget
                                                      .bookingModel
                                                      .hospitalDetails!
                                                      .fcmToken!,
                                                  orderId:
                                                      widget.bookingModel.id!);
                                            },
                                          );
                                        }
                                      }

                                      Navigator.pop(context);
                                    },
                                  ));
                        }),
                    const Gap(20),
                    ButtonWidget(
                        onPressed: () async {
                          await LaunchDialer.lauchDialer(
                              phoneNumber: widget
                                  .bookingModel.hospitalDetails!.phoneNo!);
                        },
                        buttonHeight: 42,
                        buttonWidth: 170,
                        buttonColor: BColors.mainlightColor,
                        buttonWidget: const Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: BColors.white,
                              size: 18,
                            ),
                            Gap(10),
                            Text(
                              'Call Hospital',
                              style: TextStyle(
                                  color: BColors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/* ------------------------------ ORDER SUMMARY CARD----------------------------- */

class OrderSummaryCardPaymentHosp extends StatelessWidget {
  const OrderSummaryCardPaymentHosp({
    super.key,
    required this.totalAmount,
    required this.timeSlot,
  });

  final num totalAmount;

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
            Column(
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
            const Gap(8),
            const Divider(),
            const Gap(8),
            AmountRow(
              text: 'Consultation Fee',
              amountValue: '₹$totalAmount',
              amountColor: BColors.black.withOpacity(0.7),
              textColor: BColors.black.withOpacity(0.7),
              fontSize: 16,
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
