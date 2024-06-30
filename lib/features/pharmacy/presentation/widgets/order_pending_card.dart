import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/textfield_alertbox.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/date_and_order_id.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_detail_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/product_view_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyPendingCard extends StatelessWidget {
  const PharmacyPendingCard({
    super.key,
    required this.pendingorderData,
    required this.index,
  });

  final PharmacyOrderModel pendingorderData;
  final int index;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<PharmacyOrderProvider>(context);

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
              OrderIDAndDateSection(
                orderData: pendingorderData,
                date: orderProvider.dateFromTimeStamp(
                    pendingorderData.createdAt ?? Timestamp.now()),
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
                          image:
                              pendingorderData.pharmacyDetails?.pharmacyImage ??
                                  '')),
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
                          (pendingorderData.productDetails!.isNotEmpty &&
                                  pendingorderData.productDetails != null)
                              ? const Text(
                                  'Items Ordered :',
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
                          if (pendingorderData.productDetails!.isNotEmpty)
                            ProductShowContainer(orderData: pendingorderData),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 RowTextContainerWidget(
                                    text1: 'Delivery : ',
                                    text2: orderProvider.deliveryType(
                                              pendingorderData.deliveryType ?? ''),
                                        
                                    text1Color: BColors.textLightBlack,
                                    fontSizeText1: 12,
                                    fontSizeText2: 12,
                                    fontWeightText1: FontWeight.w600,
                                    text2Color: BColors.textBlack,
                                  ),
                                  const Gap(6),
                                if (pendingorderData.productDetails!.isNotEmpty)
                                  RowTextContainerWidget(
                                    text1: 'Amount to be paid : ',
                                    text2:
                                        '₹ ${pendingorderData.totalDiscountAmount}',
                                    text1Color: BColors.textLightBlack,
                                    fontSizeText1: 13,
                                    fontSizeText2: 13,
                                    fontWeightText1: FontWeight.w600,
                                    text2Color: BColors.green,
                                  ),
                                const Divider(),
                              ],
                            ),
                          ),
                        
                          PharmacyDetailsContainer(
                              pharmacyData: pendingorderData.pharmacyDetails!),
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
                        hintText: 'Let us know more about cancellation.',
                        titleText: 'Confrim to cancel !',
                        subText: 'Are you sure you want to confirm the cancellation of this order?',
                        confirmButtonTap: () {
                          LoadingLottie.showLoading(
                              context: context, text: 'Cancelling...');
                          orderProvider
                              .cancelPendingOrder(
                                  index: index, orderData: pendingorderData)
                              .whenComplete(() => Navigator.pop(context));
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
