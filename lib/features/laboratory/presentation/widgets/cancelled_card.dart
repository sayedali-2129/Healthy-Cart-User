import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CancelledCard extends StatelessWidget {
  const CancelledCard({
    super.key,
    required this.screenWidth,
    required this.index,
  });

  final double screenWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      final orders = ordersProvider.cancelledOrders[index];

      final rejectedAt = orders.rejectedAt!.toDate();

      final formattedDate = DateFormat('dd/MM/yyyy').format(rejectedAt);
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
                          image: orders.labDetails!.image!)),
                  const Gap(20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /* ---------------------------------- DATE ---------------------------------- */

                        const Gap(5),
                        /* -------------------------------------------------------------------------- */
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orders.rejectReason == null
                                ? Expanded(
                                    child: Text(
                                      'Your Booking is Cancelled',
                                      style: TextStyle(
                                          color: BColors.red,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : Expanded(
                                    child: Text(
                                      'Your Booking is Cancelled By Lab',
                                      style: TextStyle(
                                          color: BColors.red,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                            Gap(5),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Center(
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(5),
                        orders.selectedTest!.length == 1
                            ? Text(orders.selectedTest!.first.testName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15))
                            : Text(
                                '${orders.selectedTest!.first.testName!} & ${orders.selectedTest!.length - 1} More',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
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
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              orders.labDetails!.laboratoryName,
                                          style: const TextStyle(
                                            color: BColors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                          )),
                                      TextSpan(
                                        text: orders.labDetails!.address,
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: BColors.black),
                                      )
                                    ])))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              orders.rejectReason != null
                  ? Text(
                      'Reject Reason : ${orders.rejectReason}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  : const Gap(0)
            ],
          ),
        ),
      );
    });
  }
}
