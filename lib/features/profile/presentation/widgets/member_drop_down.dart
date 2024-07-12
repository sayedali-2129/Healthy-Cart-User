
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_family_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';


class FamilyMembersGenderDropdown extends StatelessWidget {
  const FamilyMembersGenderDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> genderList = ['Male', 'Female', 'Other','unspecified'];

    return Consumer<UserFamilyMembersProvider>(builder: (context, value, _) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String>(
                value: value.selectedGenderDrop,
                validator: BValidator.validate,
                hint: const Text('Select Gender'),
                dropdownColor: BColors.white,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                items: genderList
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (dropDownValue) {
                  value.selectedGenderDrop = dropDownValue;
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
