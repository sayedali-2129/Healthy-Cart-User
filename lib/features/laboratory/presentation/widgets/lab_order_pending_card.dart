import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/textfield_alertbox.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_details_card_on_orders.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_order_id_and_date.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/ordered_selected_tests_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingCard extends StatelessWidget {
  const PendingCard({
    super.key,
    required this.pendingorderData,
    required this.index,
  });

  final LabOrdersModel pendingorderData;
  final int index;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<LabOrdersProvider>(context);
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(pendingorderData.orderAt!.toDate());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
        ),
        child:
            //MAIN COLUMN
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabOrderIdAndDate(
                orderData: pendingorderData,
                date: formattedDate,
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 64,
                      width: 64,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CustomCachedNetworkImage(
                          image: pendingorderData.labDetails?.image ?? '')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your order is on pending',
                            style: TextStyle(
                                color: Color(0xffEB9025),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          const Gap(6),
                          (pendingorderData.selectedTest!.isNotEmpty &&
                                  pendingorderData.selectedTest != null)
                              ? const Text(
                                  'Tests Booked :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                )
                              : const Text(
                                  'Prescription is on review.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                          const Gap(6),
                          if (pendingorderData.selectedTest!.isNotEmpty)
                            OrderedSelectedTestsCard(
                                orderData: pendingorderData),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RowTextContainerWidget(
                                  text1: 'Test Mode : ',
                                  text2: pendingorderData.testMode == 'Lab'
                                      ? 'At Lab'
                                      : 'Home',
                                  text1Color: BColors.textLightBlack,
                                  fontSizeText1: 12,
                                  fontSizeText2: 12,
                                  fontWeightText1: FontWeight.w600,
                                  text2Color: BColors.textBlack,
                                ),
                              if(pendingorderData.usertimeSlot != null)
                               RowTextContainerWidget(
                                  text1: 'Time Slot : ',
                                  text2: '${pendingorderData.usertimeSlot}',
                                  text1Color: BColors.textLightBlack,
                                  fontSizeText1: 12,
                                  fontSizeText2: 12,
                                  fontWeightText1: FontWeight.w600,
                                  text2Color: BColors.textBlack,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                          LabDetailsCardOnOrders(
                              labData: pendingorderData.labDetails!),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      orderProvider.rejectionReasonController.clear();
                      TextFieldAlertBoxWidget.showAlertTextFieldBox(
                        context: context,
                        controller: orderProvider.rejectionReasonController,
                        maxlines: 3,
                        hintText:
                            'Let us know more about cancellation (optional)',
                        titleText: 'Confrim to cancel !',
                        subText:
                            'Are you sure you want to confirm the cancellation of this Booking?',
                        confirmButtonTap: () {
                          ConfirmAlertBoxWidget.showAlertConfirmBox(
                            context: context,
                            titleSize: 18,
                            titleText: 'Cancel',
                            subText:
                                'Are you sure you want to cancel this order?',
                            confirmButtonTap: () async {
                              LoadingLottie.showLoading(
                                  context: context, text: 'Cancelling...');
                              await orderProvider.cancelOrder(
                                  fromPending: true,
                                  fcmtoken:
                                      pendingorderData.labDetails!.fcmToken ??
                                          '',
                                  userName:
                                      pendingorderData.userDetails!.userName ??
                                          'User',
                                  orderId: pendingorderData.id!,
                                  index: index);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const Gap(8)
            ],
          ),
        ),
      ),
    );
  }
}
