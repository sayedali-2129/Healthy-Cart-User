import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/pdf_viewer/pdf_viewer.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CompletedCard extends StatelessWidget {
  const CompletedCard({
    super.key,
    required this.screenWidth,
    required this.index,
  });

  final double screenWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      final orders = ordersProvider.completedOrders[index];
      final completedAt = orders.completedAt!.toDate();

      final formattedDate = DateFormat('dd/MM/yyyy').format(completedAt);
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [

                        //   ],
                        // ),
                        const Gap(5),
                        /* -------------------------------------------------------------------------- */
                        const Gap(5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            orders.selectedTest!.length == 1
                                ? Expanded(
                                    child: Text(
                                        orders.selectedTest!.first.testName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15)),
                                  )
                                : Expanded(
                                    child: Text(
                                      '${orders.selectedTest!.first.testName!} & ${orders.selectedTest!.length - 1} More',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
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
              const Gap(15),
              ButtonWidget(
                buttonHeight: 42,
                buttonWidth: screenWidth,
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
                          pdfName: orders.userDetails!.userName!,
                          pdfUrl: orders.resultUrl!,
                          title: orders.userDetails!.userName!,
                          headingColor: BColors.darkblue,
                        ),
                      ));
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
