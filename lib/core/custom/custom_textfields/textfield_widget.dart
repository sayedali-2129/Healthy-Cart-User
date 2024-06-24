import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    super.key,
    this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.validator,
    this.maxlines,
    this.minlines,
    this.labelText,
    this.style =
        const TextStyle(color: BColors.black, fontWeight: FontWeight.w500),
    this.hintText,
    this.textInputAction,
    this.onChanged,
    this.onSubmit,
    this.fieldHeading,
    this.suffixIcon,
    this.onTap,
    this.enableHeading = true,
    this.maxLendth,
  });
  final TextEditingController? controller;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxlines;
  final int? minlines;
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final String? fieldHeading;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final bool? enableHeading;
  final int? maxLendth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        enableHeading == true
            ? Text(
                fieldHeading!,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BColors.black),
              )
            : const Gap(0),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            child: TextFormField(
              onChanged: onChanged,
              maxLength: maxLendth,
              onTap: onTap,
              textInputAction: textInputAction,
              textCapitalization: TextCapitalization.sentences,
              minLines: maxlines,
              maxLines: maxlines,
              validator: validator,
              keyboardType: keyboardType,
              controller: controller,
              readOnly: readOnly!,
              cursorColor: BColors.black,
              onFieldSubmitted: onSubmit,
              style: style,
              decoration: InputDecoration(
                counterText: '',
                labelStyle: Theme.of(context).textTheme.labelMedium,
                hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BColors.grey),
                hintText: hintText,
                labelText: labelText,
                suffixIcon: suffixIcon,
                // contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: BColors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
