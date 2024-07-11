
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class DeliveryTypeRadiopopup extends StatelessWidget {
  const DeliveryTypeRadiopopup({
    super.key,
    this.onConfirm,
  });

  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, provider, _) {
      return AlertDialog(
        backgroundColor: BColors.white,
        title: const Text(
          'What do you prefer?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioMenuButton(
              value: provider.homeDelivery,
              groupValue: provider.selectedRadio,
              onChanged: (value) {
                provider.setSelectedRadio(value);
              },
              child: const Text('Home Delivery'),
            ),
            RadioMenuButton(
              value: provider.pharmacyPickup,
              groupValue: provider.selectedRadio,
              onChanged: (value) {
                provider.setSelectedRadio(value);
              },
              child: const Text('Pharmacy Pick-Up'),
            ),
            const Gap(16),
            ButtonWidget(
              buttonHeight: 40,
              buttonWidth: 120,
              buttonColor: BColors.darkblue,
              buttonWidget: const Text('Confirm',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.white)),
              onPressed: onConfirm,
            ),
          ],
        ),
      );
    });
  }
}