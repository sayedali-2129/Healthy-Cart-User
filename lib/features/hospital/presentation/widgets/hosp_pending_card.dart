import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/confirm_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hosp_booking_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class HospPendingCard extends StatelessWidget {
  const HospPendingCard({
    super.key,
    required this.screenWidth,
    required this.index,
  });

  final double screenWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<HospitalBookingProivder>(
        builder: (context, ordersProvider, _) {
      final orders = ordersProvider.pendingList[index];
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
                          image: orders.selectedDoctor!.doctorImage!)),
                  const Gap(20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Booking is on Pending',
                          style: TextStyle(
                              color: Color(0xffEB9025),
                              fontWeight: FontWeight.w600),
                        ),
                        const Gap(5),
                        Text(
                          'Dr. ${orders.selectedDoctor!.doctorName} (${orders.selectedDoctor!.doctorQualification})',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const Gap(5),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Patient Name :- ',
                                  style: const TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    fontFamily: 'Montserrat',
                                  )),
                              TextSpan(
                                text: orders.patientName,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: BColors.black),
                              )
                            ],
                          ),
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
                                            '${orders.hospitalDetails!.hospitalName} ',
                                        style: const TextStyle(
                                          color: BColors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          fontFamily: 'Montserrat',
                                        )),
                                    TextSpan(
                                      text: orders.hospitalDetails!.address,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ButtonWidget(
                  //   buttonHeight: 35,
                  //   buttonWidth: 140,
                  //   buttonColor: BColors.darkblue,
                  //   buttonWidget: const Text(
                  //     'View Details',
                  //     style: TextStyle(
                  //         color: BColors.white, fontWeight: FontWeight.w500),
                  //   ),
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //         backgroundColor: BColors.white,
                  //         title: const Text(
                  //           'Bookings Details',
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w600, fontSize: 16),
                  //         ),
                  //         content: Column(
                  //           children: [
                  //             SizedBox(
                  //               height: 500,
                  //               width: 300,
                  //               child: ListView.separated(
                  //                   physics:
                  //                       const NeverScrollableScrollPhysics(),
                  //                   shrinkWrap: true,
                  //                   separatorBuilder: (context, index) =>
                  //                       const Gap(8),
                  //                   itemCount: orders.selectedTest!.length,
                  //                   itemBuilder: (context, testIndex) {
                  //                     return SelectedItemsCard(
                  //                       index: testIndex,
                  //                       testName: orders
                  //                           .selectedTest![testIndex].testName,
                  //                       testPrice: orders
                  //                           .selectedTest![testIndex].testPrice
                  //                           .toString(),
                  //                       offerPrice: orders
                  //                           .selectedTest![testIndex].offerPrice
                  //                           .toString(),
                  //                       image: orders
                  //                           .selectedTest![testIndex].testImage,
                  //                     );
                  //                   }),
                  //             ),
                  //             OrderSummaryCard(
                  //                 totalTestFee: ordersProvider
                  //                     .claculateTotalTestFee(index),
                  //                 discount: ordersProvider.totalDicount(index),
                  //                 totalAmount: ordersProvider
                  //                     .claculateTotalAmount(index),
                  //                 index: index)
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  OutlineButtonWidget(
                    buttonHeight: 35,
                    buttonWidth: 140,
                    buttonColor: BColors.white,
                    borderColor: BColors.black,
                    buttonWidget: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: BColors.black, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      ConfirmAlertBoxWidget.showAlertConfirmBox(
                        context: context,
                        titleSize: 18,
                        titleText: 'Cancel',
                        subText: 'Are you sure you want to cancel this order?',
                        confirmButtonTap: () async {
                          LoadingLottie.showLoading(
                              context: context, text: 'Cancelling...');
                          await ordersProvider.cancelOrder(
                              orderId: orders.id!, index: index);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

// class OrderSummaryCard extends StatelessWidget {
//   const OrderSummaryCard({
//     super.key,
//     required this.totalTestFee,
//     required this.discount,
//     required this.totalAmount,
//     required this.index,
//   });
//   final num totalTestFee;
//   final num discount;
//   final num totalAmount;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         border: Border.all(),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Text(
//               'Order Summary',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: BColors.green),
//             ),
//             const Gap(16),
//             AmountRow(
//               text: 'Total Test Fee',
//               amountValue: '₹$totalTestFee',
//             ),
//             const Gap(8),
//             Consumer<HospitalBookingProivder>(builder: (context, value, _) {
//               if (value.pendingList[index].selectedTest![index].offerPrice ==
//                   null) {
//                 return const Gap(0);
//               } else {
//                 return AmountRow(
//                   text: 'Discount',
//                   amountValue: '$discount',
//                   amountColor: BColors.green,
//                   textColor: BColors.green,
//                 );
//               }
//             }),
//             const Gap(8),
//             const Divider(),
//             const Gap(8),
//             AmountRow(
//               text: 'Total Amount',
//               amountValue: '₹$totalAmount',
//               amountColor: BColors.black.withOpacity(0.7),
//               textColor: BColors.black.withOpacity(0.7),
//               fontSize: 18,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AmountRow extends StatelessWidget {
//   const AmountRow(
//       {super.key,
//       required this.text,
//       required this.amountValue,
//       this.textColor = BColors.black,
//       this.amountColor = BColors.black,
//       this.fontSize = 15});
//   final String text;
//   final String amountValue;
//   final Color? textColor;
//   final Color? amountColor;
//   final double? fontSize;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           text,
//           style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w500,
//               color: textColor),
//         ),
//         Text(
//           amountValue,
//           style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w500,
//               color: amountColor),
//         ),
//       ],
//     );
//   }
// }
