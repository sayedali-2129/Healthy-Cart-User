import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class CustomSliverSearchAppBar extends StatelessWidget {
  const CustomSliverSearchAppBar({
    super.key,
    required this.onTapBackButton,
    required this.searchOnChanged,
    required this.searchHint,
    this.controller, this.onSubmitted,
  });
  final String searchHint;
  final VoidCallback onTapBackButton;
  final void Function(String) searchOnChanged;
   final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: BColors.mainlightColor,
      titleSpacing: -1,
      pinned: true,
      floating: true,
      forceElevated: true,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      leading: GestureDetector(
        onTap: onTapBackButton,
        child: const Icon(
          Icons.arrow_back_ios,
          color: BColors.darkblue,
        ),
      ),
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
        child: TextField(
          onSubmitted: onSubmitted,
          onChanged: searchOnChanged,
          controller: controller,
          showCursor: false,
          autofocus: true,
          cursorColor: BColors.black,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
            hintText: searchHint,
            hintStyle: const TextStyle(fontSize: 14),
            suffixIcon: const Icon(
              Icons.search_outlined,
              color: BColors.darkblue,
            ),
            filled: true,
            fillColor: BColors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(26),
            ),
          ),
        ),
      ),
    );
  }
}
