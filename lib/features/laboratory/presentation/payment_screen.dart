import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/launch_dialer.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/payment_status_screen.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/core/services/razorpay_service.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/general/presentation/provider/general_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/payment_type_radio.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/selected_tests_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/app_details.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LabPaymentScreen extends StatefulWidget {
  const LabPaymentScreen({
    super.key,
    required this.labOrdersModel,
  });
  final LabOrdersModel labOrdersModel;

  @override
  State<LabPaymentScreen> createState() => _LabPaymentScreenState();
}

class _LabPaymentScreenState extends State<LabPaymentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<GeneralProvider>().fetchData();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LabOrdersProvider, GeneralProvider>(
      builder: (context, ordersProvider, generalProvider, _) {
        return PopScope(
          onPopInvoked: (didPop) {
            ordersProvider.paymentType = null;
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
                                  text:
                                      '${widget.labOrdersModel.labDetails!.laboratoryName}- ',
                                  style: const TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${widget.labOrdersModel.labDetails!.address}',
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
                    const Gap(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID :- ${widget.labOrdersModel.id}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Gap(10),
                    /* -------------------------------- TEST LIST ------------------------------- */
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Gap(8),
                        itemCount: widget.labOrdersModel.selectedTest!.length,
                        itemBuilder: (context, testIndex) {
                          return SelectedTestsCard(
                            testIndex: testIndex,
                            labOrdersModel: widget.labOrdersModel,
                            testName: widget.labOrdersModel
                                .selectedTest![testIndex].testName,
                            testPrice: widget.labOrdersModel
                                .selectedTest![testIndex].testPrice,
                            offerPrice: widget.labOrdersModel
                                .selectedTest![testIndex].offerPrice,
                            image: widget.labOrdersModel
                                    .selectedTest![testIndex].testImage ??
                                '',
                          );
                        }),
                    const Gap(10),
                    /* --------------------------------- ADDRESS -------------------------------- */
                    if (widget.labOrdersModel.testMode == 'Home')
                      AddressCardPaymentScreen(
                          labOrdersModel: widget.labOrdersModel),
                    if (widget.labOrdersModel.notes != null &&
                        widget.labOrdersModel.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: BColors.mainlightColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: RowTextContainerWidget(
                              text1: 'Note by laboratory : ',
                              text2:
                                  widget.labOrdersModel.notes ?? 'Unknown note',
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 12,
                              fontSizeText2: 13,
                              fontWeightText1: FontWeight.w600,
                              text2Color: BColors.black),
                        ),
                      ),
                    const Gap(10),
                    /* ------------------------------ ORDER SUMMARY ----------------------------- */
                    OrderSummaryCardPayment(
                        labOrdersModel: widget.labOrdersModel,
                        admintimeSlot:
                            widget.labOrdersModel.admintimeSlot ?? '',
                        usertimeSlot: widget.labOrdersModel.usertimeSlot ?? '',
                        totalTestFee: widget.labOrdersModel.totalAmount!,
                        doorStepCharge: widget.labOrdersModel.doorStepCharge!,
                        totalAmount: widget.labOrdersModel.finalAmount!),
                    const Gap(10),

                    /* ----------------------------- PAYMENT BUTTON ----------------------------- */

                    widget.labOrdersModel.finalAmount == 0
                        ? ButtonWidget(
                            buttonHeight: 45,
                            buttonWidth: double.infinity,
                            buttonColor: const Color(0xff367CBD),
                            buttonWidget: const Text(
                              'Accept Booking',
                              style: TextStyle(
                                  color: BColors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              ConfirmAlertBoxWidget.showAlertConfirmBox(
                                  context: context,
                                  confirmButtonTap: () async {
                                    LoadingLottie.showLoading(
                                        context: context,
                                        text: 'Please Wait..');

                                    await ordersProvider
                                        .acceptOrder(
                                            paymentType: 'Doorstep Payment',
                                            paymentStatus: 1,
                                            userName: widget.labOrdersModel
                                                .userDetails!.userName!,
                                            fcmtoken: widget.labOrdersModel
                                                .labDetails!.fcmToken!,
                                            orderId: widget.labOrdersModel.id!)
                                        .whenComplete(
                                      () {
                                        ordersProvider.singleOrderDoc = null;

                                        EasyNavigation.push(
                                          context: context,
                                          page: const OrderRequestSuccessScreen(
                                              title:
                                                  'Your Booking is successfully completed!'),
                                          type: PageTransitionType.bottomToTop,
                                        );
                                      },
                                    );
                                  },
                                  titleText: 'Confirm',
                                  subText:
                                      'Are you sure want to confirm this booking?');
                            },
                          )
                        : ButtonWidget(
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
                                  builder: (context) => PaymentTypeRadioLab(
                                        onConfirm: () async {
                                          // log(ordersProvider.paymentType ??
                                          //     'null');
                                          if (ordersProvider.paymentType ==
                                              null) {
                                            CustomToast.infoToast(
                                                text:
                                                    'Select preffered payment method');
                                            return;
                                          } else {
                                            if (generalProvider.generalModel
                                                    ?.razorpayKey ==
                                                null) {
                                              CustomToast.errorToast(
                                                  text:
                                                      'Unable to process the payment');
                                              return;
                                            }
                                            LoadingLottie.showLoading(
                                                context: context,
                                                text: 'Loading...');
                                            if (ordersProvider.paymentType ==
                                                'Doorstep Payment') {
                                              await ordersProvider
                                                  .acceptOrder(
                                                      paymentStatus: 0,
                                                      paymentType:
                                                          ordersProvider
                                                              .paymentType,
                                                      userName: widget
                                                          .labOrdersModel
                                                          .userDetails!
                                                          .userName!,
                                                      fcmtoken: widget
                                                          .labOrdersModel
                                                          .labDetails!
                                                          .fcmToken!,
                                                      orderId: widget
                                                          .labOrdersModel.id!)
                                                  .whenComplete(
                                                () {
                                                  ordersProvider
                                                      .singleOrderDoc = null;
                                                  ordersProvider.paymentType ==
                                                      null;
                                                },
                                              );

                                              await EasyNavigation.push(
                                                context: context,
                                                page:
                                                    const OrderRequestSuccessScreen(
                                                  title:
                                                      'Your Booking is Successfull!!',
                                                ),
                                                type: PageTransitionType
                                                    .bottomToTop,
                                              );

                                              Navigator.pop(context);
                                            } else {
                                              final user = context
                                                  .read<
                                                      AuthenticationProvider>()
                                                  .userFetchlDataFetched!;
                                              RazorpayService.pay(
                                                amount: widget.labOrdersModel
                                                    .finalAmount!,
                                                rzpKey: generalProvider
                                                    .generalModel!.razorpayKey,
                                                razorpayKeySecret:
                                                    generalProvider
                                                        .generalModel!
                                                        .razorpayKeySecret,
                                                appName: AppDetails.appName,
                                                userProfile: RzpUserProfile(
                                                  uid: user.id!,
                                                  name: user.userName,
                                                  email: user.userEmail,
                                                  phoneNumber: user.phoneNo,
                                                ),
                                                failure: (response) {
                                                  Get.to(
                                                    () => PaymentStatusScreen(
                                                        isErrorPage: true,
                                                        bookingId:
                                                            response.message),
                                                  );

                                                  CustomToast.errorToast(
                                                      text:
                                                          'Payment Failed ORDER ID: ${response.message!}');
                                                },
                                                success: (response) async {
                                                  CustomToast.sucessToast(
                                                      text:
                                                          'Payment Successful ORDER ID: ${response.paymentId!}');

                                                  await ordersProvider
                                                      .acceptOrder(
                                                          paymentId: response
                                                              .paymentId,
                                                          paymentStatus: 1,
                                                          paymentType:
                                                              ordersProvider
                                                                  .paymentType,
                                                          userName: widget
                                                              .labOrdersModel
                                                              .userDetails!
                                                              .userName!,
                                                          fcmtoken: widget
                                                              .labOrdersModel
                                                              .labDetails!
                                                              .fcmToken!,
                                                          orderId: widget
                                                              .labOrdersModel
                                                              .id!)
                                                      .whenComplete(
                                                    () {
                                                      ordersProvider
                                                              .paymentType ==
                                                          null;
                                                      ordersProvider
                                                              .singleOrderDoc =
                                                          null;

                                                      EasyNavigation.push(
                                                        context: context,
                                                        page: PaymentStatusScreen(
                                                            isErrorPage: false,
                                                            bookingId: response
                                                                .paymentId),
                                                      );
                                                    },
                                                  );
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
                          log('Contact number :::: ${widget.labOrdersModel.labDetails?.contactNumber}');
                          await LaunchDialer.lauchDialer(
                              phoneNumber:
                                  '${widget.labOrdersModel.labDetails?.contactNumber ?? widget.labOrdersModel.labDetails?.phoneNo}');
                        },
                        buttonHeight: 42,
                        buttonWidth: 140,
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
                              'Call Lab',
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

class OrderSummaryCardPayment extends StatelessWidget {
  const OrderSummaryCardPayment({
    super.key,
    required this.totalTestFee,
    required this.doorStepCharge,
    required this.totalAmount,
    required this.usertimeSlot,
    required this.admintimeSlot,
    required this.labOrdersModel,
  });
  final num totalTestFee;
  final num doorStepCharge;
  final num totalAmount;
  final LabOrdersModel labOrdersModel;
  final String? usertimeSlot;
  final String? admintimeSlot;
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
            if (labOrdersModel.tokenNumber != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: BColors.offRed),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Token No- ${labOrdersModel.tokenNumber}',
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                  )),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time Scheduled : ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BColors.black),
                  ),
                  ((admintimeSlot != null) &&
                          (admintimeSlot!.isNotEmpty) &&
                          (admintimeSlot!.trim() != usertimeSlot!.trim()))
                      ? Expanded(
                          child: Column(
                            children: [
                              Text(
                                '$usertimeSlot',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.buttonLightBlue),
                              ),
                              const Text(
                                'Changed To',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.grey),
                              ),
                              Text(
                                '$admintimeSlot',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.buttonLightBlue),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          '$usertimeSlot',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: BColors.buttonLightBlue),
                        ),
                ],
              ),
            ),
            const Gap(16),
            AmountRow(
              text: 'Total Test Fee',
              amountValue: totalTestFee == 0 ? 'Free Test' : '₹$totalTestFee',
              fontSize: 14,
            ),
            const Gap(8),
            Consumer<LabOrdersProvider>(builder: (context, value, _) {
              if (labOrdersModel.testMode == 'Home') {
                return (labOrdersModel.doorStepCharge == 0 ||
                        labOrdersModel.doorStepCharge == null)
                    ? AmountRow(
                        text: 'Door Step Charge',
                        amountValue: 'Free Service',
                        amountColor: BColors.green,
                        fontSize: 14,
                      )
                    : AmountRow(
                        text: 'Door Step Charge',
                        amountValue: '₹$doorStepCharge',
                        fontSize: 14,
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
              amountValue: totalAmount == 0 ? 'Free Test' : '₹$totalAmount',
              amountColor: totalAmount == 0
                  ? BColors.green
                  : BColors.black.withOpacity(0.7),
              textColor: BColors.black.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
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
      this.fontSize = 15,
      this.fontWeight});
  final String text;
  final String amountValue;
  final Color? textColor;
  final Color? amountColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: fontWeight ?? FontWeight.w500,
          ),
        ),
        Text(
          amountValue,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: amountColor),
        ),
      ],
    );
  }
}

class AddressCardPaymentScreen extends StatelessWidget {
  const AddressCardPaymentScreen({
    super.key,
    required this.labOrdersModel,
  });
  final LabOrdersModel labOrdersModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Address :-',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: BColors.black),
            ),
          ],
        ),
        const Gap(5),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            labOrdersModel.userAddress!.name ?? 'User',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const Gap(8),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all()),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  labOrdersModel.userAddress!.addressType ??
                                      'Home',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(5),
                      Text(
                        '${labOrdersModel.userAddress!.address ?? 'Address'} ${labOrdersModel.userAddress!.landmark ?? 'Address'} - ${labOrdersModel.userAddress!.pincode ?? 'Address'}',
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 3,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Gap(5)
                    ],
                  ),
                  Text(
                    labOrdersModel.userAddress!.phoneNumber ?? '0000000000',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
