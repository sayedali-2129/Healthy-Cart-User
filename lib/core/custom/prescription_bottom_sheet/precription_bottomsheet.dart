import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ChooseButton extends StatelessWidget {
  const ChooseButton({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.buttonTap,
  });
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback buttonTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: BColors.white,
      surfaceTintColor: BColors.white,
      child: InkWell(
        onTap: buttonTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SizedBox(
            width: 72,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: iconColor),
                const Gap(8),
                Text(text,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.darkblue,),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChoosePrescriptionBottomSheet extends StatelessWidget {
  const ChoosePrescriptionBottomSheet({
    super.key, required this.cameraButtonTap, required this.galleryButtonTap,
  });
  final VoidCallback cameraButtonTap;
  final VoidCallback galleryButtonTap;  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
         const Padding(
            padding:  EdgeInsets.only(top: 8, bottom: 24),
            child: Text('Choose a prescription from :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: BColors.darkblue,)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChooseButton(
                buttonTap: cameraButtonTap,
                text: 'Camera',
                icon: Icons.camera_alt_outlined,
                iconColor: BColors.mainlightColor,
              ),
              ChooseButton(
                buttonTap: galleryButtonTap,
                text: "Gallery",
                icon: Icons.photo_library_outlined,
                iconColor: BColors.mainlightColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
