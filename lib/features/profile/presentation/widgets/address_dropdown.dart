import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class AddressDropDown extends StatelessWidget {
  const AddressDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> addressList = ['Home', 'Work', 'Other'];

    return Consumer<UserAddressProvider>(builder: (context, value, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            // height: 55,
            child: DropdownButtonFormField<String>(
              value: value.selectedAddressType,
              validator: BValidator.validate,
              hint: const Text(
                'Address Type',
                style: TextStyle(fontSize: 15),
              ),
              dropdownColor: BColors.white,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: BColors.black)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: BColors.black)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              ),
              items: addressList
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (dropDownValue) {
                value.selectedAddressType = dropDownValue;
              },
            ),
          ),
        ],
      );
    });
  }
}
