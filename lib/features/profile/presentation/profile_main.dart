import 'package:flutter/material.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        backgroundColor: BColors.mainlightColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8))),
        title: const Text(
          'Check Out',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        shadowColor: BColors.black.withOpacity(0.8),
        elevation: 5,
      ),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
