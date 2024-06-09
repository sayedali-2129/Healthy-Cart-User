import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class TestTypeRadiopopup extends StatelessWidget {
  const TestTypeRadiopopup({
    super.key,
    this.onConfirm,
  });

  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, provider, _) {
      return PopScope(
        // onPopInvoked: (didPop) {
        //   provider.selectedRadio = null;
        // },
        child: AlertDialog(
          backgroundColor: BColors.white,
          title: const Text(
            'What do you prefer?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioMenuButton(
                value: 'Home',
                groupValue: provider.selectedRadio,
                onChanged: (value) {
                  provider.setSelectedRadio(value);
                },
                child: const Text('Home'),
              ),
              RadioMenuButton(
                value: 'Lab',
                groupValue: provider.selectedRadio,
                onChanged: (value) {
                  provider.setSelectedRadio(value);
                },
                child: const Text('Lab'),
              ),
              const Gap(10),
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
        ),
      );
    });
  }
}
