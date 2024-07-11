import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_details_card_on_orders.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_order_id_and_date.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ordered_selected_tests_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';

class LabOrderCancelledCard extends StatelessWidget {
  const LabOrderCancelledCard({super.key, required this.cancelledOrderData});
  final LabOrdersModel cancelledOrderData;
  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<LabOrdersProvider>(context);
    final formattedDate = DateFormat('dd/MM/yyyy')
        .format(cancelledOrderData.rejectedAt!.toDate());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LabOrderIdAndDate(
                  orderData: cancelledOrderData, date: formattedDate),
              const Gap(8),
              Row(
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: BColors.offRed,
                    size: 40,
                  ),
                  const Gap(8),
                  Text(
                    'Booking Cancelled !',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BColors.offRed,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              if (cancelledOrderData.selectedTest!.isNotEmpty)
                OrderedSelectedTestsCard(orderData: cancelledOrderData),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cancelledOrderData.selectedTest!.isNotEmpty)
                      RowTextContainerWidget(
                        text1: 'Total Amount : ',
                        text2: cancelledOrderData.finalAmount == 0 ||
                                cancelledOrderData.finalAmount == null
                            ? '₹ ${cancelledOrderData.totalAmount}'
                            : '₹ ${cancelledOrderData.totalAmount}',
                        text1Color: BColors.textLightBlack,
                        fontSizeText1: 13,
                        fontSizeText2: 13,
                        fontWeightText1: FontWeight.w600,
                        text2Color: BColors.green,
                      ),
                    const Divider(),
                    RowTextContainerWidget(
                      text1: 'Rejected by : ',
                      text2: (cancelledOrderData.isRejectedByUser == true)
                          ? 'User'
                          : 'Laboratory',
                      text1Color: BColors.textLightBlack,
                      fontSizeText1: 12,
                      fontSizeText2: 13,
                      fontWeightText1: FontWeight.w600,
                      text2Color: BColors.red,
                    ),
                    const Gap(6),
                    (cancelledOrderData.rejectReason == null ||
                            cancelledOrderData.rejectReason!.isEmpty)
                        ? const SizedBox()
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: BColors.mainlightColor),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rejection reason :',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: BColors.textLightBlack,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                ),
                                const Gap(6),
                                Text(
                                  cancelledOrderData.rejectReason ??
                                      'Unknown reason',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                    const Divider(),
                    LabDetailsCardOnOrders(
                      labData: cancelledOrderData.labDetails ?? LabModel(),
                    ),
                    const Gap(16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
