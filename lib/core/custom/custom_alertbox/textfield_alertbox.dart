import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/textfield_widget.dart';
import 'package:healthy_cart_user/core/general/validator.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class TextFieldAlertBoxWidget {
  static void showAlertTextFieldBox(
      {required BuildContext context,
      required VoidCallback confirmButtonTap,
      required String titleText,
      required String hintText,
      required String subText,
      required TextEditingController controller,
      int? maxlines,
      TextInputType? keyboardType,
      }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          child: AlertDialog(
            backgroundColor: BColors.white,
            title: Text(titleText,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat')),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(subText,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat')),
                const Gap(4),
                TextfieldWidget(
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat'),
                  hintText: hintText,
                  keyboardType: keyboardType,
                  textInputAction: TextInputAction.done,
                  validator: BValidator.validate,
                  controller: controller,
                  maxlines: maxlines,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    EasyNavigation.pop(context: context);
                  },
                  child: const Text('No',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: BColors.darkblue))),
              ElevatedButton(
                  onPressed: () {
                    EasyNavigation.pop(context: context);
                    confirmButtonTap.call();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: BColors.mainlightColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text('Confirm',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: BColors.textWhite))),
            ],
          ),
        );
      },
    );
  }
}
