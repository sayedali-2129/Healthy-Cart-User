import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:pinput/pinput.dart';

class PinputWidget extends StatelessWidget {
  const PinputWidget({
    super.key,
    required this.onSubmitted,
    required this.controller,
  });
  final void Function(String) onSubmitted;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: BColors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: BColors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: BColors.darkblue),
      borderRadius: BorderRadius.circular(16),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: BColors.lightGrey,
      ),
    );
    return Pinput(
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      defaultPinTheme: defaultPinTheme,
      length: 6,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      closeKeyboardWhenCompleted: true,
      onSubmitted: onSubmitted,
      controller: controller,
    );
  }
}
