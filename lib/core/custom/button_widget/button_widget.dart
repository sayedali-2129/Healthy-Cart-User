import 'package:flutter/material.dart';

//Colored Button
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.buttonColor,
    required this.buttonWidget,
    this.onPressed,
  });
  final double buttonHeight;
  final double buttonWidth;
  final Color buttonColor;
  final Widget buttonWidget;

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(2),
            backgroundColor: WidgetStatePropertyAll(buttonColor),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: buttonWidget),
    );
  }
}

//Outline Button
class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({
    super.key,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.buttonColor,
    this.onPressed,
    required this.borderColor,
    required this.buttonWidget,
  });

  final double buttonHeight;
  final double buttonWidth;
  final Color buttonColor;

  final Color borderColor;
  final void Function()? onPressed;
  final Widget buttonWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(2),
            backgroundColor: WidgetStatePropertyAll(
              buttonColor,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            side: WidgetStatePropertyAll(
              BorderSide(color: borderColor),
            ),
          ),
          child: Center(
            child: buttonWidget,
          )),
    );
  }
}
