import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/launch_dialer.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_booking_model.dart';
import 'package:healthy_cart_user/features/hospital/presentation/hospital_payment_screen.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HospAcceptCard extends StatelessWidget {
  const HospAcceptCard({
    super.key,
    required this.screenWidth,
    required this.hospitalBookingModel,
  });

  final double screenWidth;
  final HospitalBookingModel hospitalBookingModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalBookingProivder>(
        builder: (context, ordersProvider, _) {
      return Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BColors.black.withOpacity(0.3),
              blurRadius: 5,
            ),
          ],
        ),
        child:
            //MAIN COLUMN
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 70,
                      width: 70,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CustomCachedNetworkImage(
                          image: hospitalBookingModel
                              .selectedDoctor!.doctorImage!)),
                  const Gap(20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Your Booking is Success',
                              style: TextStyle(
                                  color: BColors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Gap(5),
                            Icon(
                              Icons.check_circle_rounded,
                              color: BColors.green,
                              size: 18,
                            )
                          ],
                        ),
                        const Gap(5),
                        Text(
                          '${hospitalBookingModel.selectedDoctor!.doctorName} (${hospitalBookingModel.selectedDoctor!.doctorQualification})',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        Text(
                          '(${hospitalBookingModel.selectedDoctor!.doctorSpecialization!})',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: BColors.grey),
                        ),
                        const Gap(5),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: 'Patient Name :- ',
                                  style: TextStyle(
                                    color: BColors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                  )),
                              TextSpan(
                                text: hospitalBookingModel.patientName,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: BColors.black),
                              )
                            ],
                          ),
                        ),
                        (hospitalBookingModel.tokenNumber != null)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  height: 30,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: BColors.offRed),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          'Token No- ${hospitalBookingModel.tokenNumber}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              )),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const Gap(4),
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
                                            '${hospitalBookingModel.hospitalDetails!.hospitalName} ',
                                        style: const TextStyle(
                                          color: BColors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                        )),
                                    TextSpan(
                                      text: hospitalBookingModel
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
              const Gap(10),
              hospitalBookingModel.isUserAccepted == false
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlineButtonWidget(
                              buttonHeight: 35,
                              buttonWidth: 140,
                              buttonColor: BColors.white,
                              borderColor: BColors.black,
                              buttonWidget: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                ConfirmAlertBoxWidget.showAlertConfirmBox(
                                  context: context,
                                  titleSize: 18,
                                  titleText: 'Cancel',
                                  subText:
                                      'Are you sure you want to cancel this order?',
                                  confirmButtonTap: () async {
                                    LoadingLottie.showLoading(
                                        context: context,
                                        text: 'Cancelling...');
                                    await ordersProvider
                                        .cancelOrder(
                                            fromPending: false,
                                            fcmtoken: hospitalBookingModel
                                                .hospitalDetails!.fcmToken!,
                                            userName: hospitalBookingModel
                                                .userDetails!.userName,
                                            orderId: hospitalBookingModel.id!)
                                        .whenComplete(
                                      () {
                                        ordersProvider.singleOrderDoc = null;
                                        EasyNavigation.pop(context: context);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            ButtonWidget(
                              buttonHeight: 35,
                              buttonWidth: 140,
                              buttonColor: BColors.buttonGreen,
                              buttonWidget: const Text(
                                'Accept',
                                style: TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.fade,
                                    page: HospitalPaymentScreen(
                                      bookingModel: hospitalBookingModel,
                                    ));
                              },
                            ),
                          ],
                        ),
                        const Gap(10),
                        Column(
                          children: [
                            (hospitalBookingModel.newBookingDate == null &&
                                    hospitalBookingModel.newTimeSlot == null)
                                ? const Text(
                                    'Selected Time Slot :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    'Your time slot changed to :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: BColors.red),
                                  ),
                            const Gap(5),
                            Text(
                              '${hospitalBookingModel.newBookingDate ?? hospitalBookingModel.selectedDate} : ${hospitalBookingModel.newTimeSlot ?? hospitalBookingModel.selectedTimeSlot}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: (hospitalBookingModel.newBookingDate ==
                                              null &&
                                          hospitalBookingModel.newTimeSlot ==
                                              null)
                                      ? BColors.black
                                      : BColors.red),
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Your Time Slot :',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: BColors.red),
                            ),
                            Text(
                              '${hospitalBookingModel.newBookingDate ?? hospitalBookingModel.selectedDate} : ${hospitalBookingModel.newTimeSlot ?? hospitalBookingModel.selectedTimeSlot}',
                              style: TextStyle(
                                  color: BColors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        const Gap(10),
                        OutlineButtonWidget(
                            onPressed: () async {
                              await LaunchDialer.lauchDialer(
                                  phoneNumber:
                                      "${hospitalBookingModel.hospitalDetails?.contactNumber ??hospitalBookingModel.hospitalDetails?.phoneNo}");
                            },
                            borderColor: BColors.black,
                            buttonHeight: 38,
                            buttonWidth: 170,
                            buttonColor: BColors.white,
                            buttonWidget: const Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  color: BColors.black,
                                  size: 18,
                                ),
                                Gap(10),
                                Text(
                                  'Call Hospital',
                                  style: TextStyle(
                                      color: BColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ))
                      ],
                    ),
            ],
          ),
        ),
      );
    });
  }
}
