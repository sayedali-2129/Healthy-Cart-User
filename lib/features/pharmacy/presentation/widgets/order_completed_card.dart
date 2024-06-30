import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/date_and_order_id.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_detail_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/product_view_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyCompletedCard extends StatelessWidget {
  const PharmacyCompletedCard({super.key, required this.completedOrderData});
  final PharmacyOrderModel completedOrderData;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<PharmacyOrderProvider>(context);
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
              OrderIDAndDateSection(
                orderData: completedOrderData,
                date: orderProvider.dateFromTimeStamp(
                    completedOrderData.completedAt ?? Timestamp.now()),
              ),
              const Gap(8),
              Row(
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    color: BColors.green,
                    size: 40,
                  ),
                  const Gap(8),
                  Text('Order Completed !',
                      overflow: TextOverflow.ellipsis,
                      style:TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BColors.green,
                    ),)
                ],
              ),
              const Gap(8),
              ProductShowContainer(orderData: completedOrderData),
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
                    PharmacyDetailsContainer(
                      pharmacyData:
                          completedOrderData.pharmacyDetails ?? PharmacyModel(),
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
