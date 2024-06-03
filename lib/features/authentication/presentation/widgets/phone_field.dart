import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatelessWidget {
  const PhoneField(
      {super.key,
      required this.phoneNumberController,
      required this.countryCode});

  final TextEditingController phoneNumberController;
  final void Function(String) countryCode;
  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      disableLengthCheck: true,
      showCountryFlag: false,
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: BColors.textWhite,
        countryNameStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        searchFieldPadding: const EdgeInsets.all(8),
      ),
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: (value) {
        countryCode(value.countryCode);
      },
      controller: phoneNumberController,
      dropdownTextStyle:
          const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      initialCountryCode: 'IN',
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        filled: true,
        fillColor: BColors.textWhite,
        hintText: "Number goes here",
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
