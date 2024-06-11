import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class OrderPharmacySummaryCard extends StatelessWidget {
  const OrderPharmacySummaryCard({
    super.key,
    required this.totalTestFee,
    required this.discount,
    required this.totalAmount,
  });
  final num totalTestFee;
  final num discount;
  final num totalAmount;

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
            Text(
              'Order Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: BColors.green),
            ),
            const Gap(16),
            AmountRow(
              text: 'Total Test Fee',
              amountValue: '₹$totalTestFee',
            ),
            const Gap(8),
  
              
               AmountRow(
                  text: 'Discount',
                  amountValue: '$discount',
                  amountColor: BColors.green,
                  textColor: BColors.green,
            ),
            const Gap(8),
            const Divider(),
            const Gap(8),
            AmountRow(
              text: 'Total Amount',
              amountValue: '₹$totalAmount',
              amountColor: BColors.black.withOpacity(0.7),
              textColor: BColors.black.withOpacity(0.7),
              fontSize: 18,
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
      this.fontSize = 15});
  final String text;
  final String amountValue;
  final Color? textColor;
  final Color? amountColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: textColor),
        ),
        Text(
          amountValue,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: amountColor),
        ),
      ],
    );
  }
}