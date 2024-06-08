import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class SearchTextFieldButton extends StatelessWidget {
  const SearchTextFieldButton({
    super.key,
    required this.text,
    this.onTap,
    this.onChanged,
    this.onSubmit,
    this.searchIcon,
    required this.controller,
  });
  final String text;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final TextEditingController controller;
  final bool? searchIcon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: BColors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 3,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: onSubmit,
                style: Theme.of(context).textTheme.labelLarge!,
                decoration: InputDecoration(
                    hintText: text,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Gap(4),
          (searchIcon == true)
              ? GestureDetector(
                  onTap: onTap,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 56,
                      decoration: BoxDecoration(
                        color: BColors.mainlightColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.search,
                          color: BColors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
