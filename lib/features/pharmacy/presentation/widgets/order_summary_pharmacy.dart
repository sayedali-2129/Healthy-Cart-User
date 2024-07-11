import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class OrderSummaryPharmacyCard extends StatelessWidget {
  const OrderSummaryPharmacyCard({
    super.key,
    required this.totalProductPrice,
    required this.discount,
    required this.totalAmount,
  });
  final num totalProductPrice;
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
              text: 'Item total(MRP)',
              amountValue: '₹$totalProductPrice',
            ),
            const Gap(8),
            AmountRow(
              text: 'Total Discount',
              amountValue: '- ₹$discount',
              amountColor: BColors.green,
              textColor: BColors.green,
            ),
            const Gap(8),
            const Divider(),
            const Gap(8),
            AmountRow(
              text: 'To be paid',
              amountValue: '₹$totalAmount',
              fontWeight: FontWeight.w600,
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
  const AmountRow({
    super.key,
    required this.text,
    required this.amountValue,
    this.textColor = BColors.black,
    this.amountColor = BColors.black,
    this.fontSize = 15, this.fontWeight = FontWeight.w500,
  });
  final String text;
  final FontWeight? fontWeight;
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
              fontWeight: fontWeight,
              color: textColor),
        ),
        Text(
          amountValue,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: amountColor),
        ),
      ],
    );
  }
}
