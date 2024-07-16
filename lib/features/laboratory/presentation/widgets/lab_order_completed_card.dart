import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/pdf_viewer/pdf_viewer.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_details_card_on_orders.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_order_id_and_date.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ordered_selected_tests_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';

class LabOrderCompletedCard extends StatelessWidget {
  const LabOrderCompletedCard({super.key, required this.completedOrderData});
  final LabOrdersModel completedOrderData;
  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy')
        .format(completedOrderData.completedAt!.toDate());

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
                  orderData: completedOrderData, date: formattedDate),
              const Gap(8),
              Row(
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    color: BColors.green,
                    size: 40,
                  ),
                  const Gap(8),
                  Text(
                    'Order Completed !',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BColors.green,
                    ),
                  )
                ],
              ),
              const Gap(8),
              OrderedSelectedTestsCard(orderData: completedOrderData),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    RowTextContainerWidget(
                      text1: 'Total Amount : ',
                      text2: '₹ ${completedOrderData.finalAmount}',
                      text1Color: BColors.textLightBlack,
                      fontSizeText1: 13,
                      fontSizeText2: 13,
                      fontWeightText1: FontWeight.w600,
                      text2Color: BColors.green,
                    ),
                    const Divider(),
                    LabDetailsCardOnOrders(
                      labData: completedOrderData.labDetails ?? LabModel(),
                    ),
                    const Gap(16),
                  ],
                ),
              ),
              ButtonWidget(
                buttonHeight: 42,
                buttonWidth: MediaQuery.of(context).size.width,
                buttonColor: BColors.buttonLightBlue,
                buttonWidget: const Text(
                  'View Result',
                  style: TextStyle(
                      color: BColors.white, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPdfScreen(
                          pdfName: completedOrderData.userDetails!.userName!,
                          pdfUrl: completedOrderData.resultUrl!,
                          title: completedOrderData.userDetails!.userName!,
                          headingColor: BColors.darkblue,
                        ),
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
