import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<LabProvider>(builder: (context, labProvider, _) {
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '2 Test Selected',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Gap(8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                  ),
                  const Gap(5),
                  Expanded(
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: TextSpan(children: [
                            TextSpan(
                                text:
                                    '${labProvider.labList[index].laboratoryName}- ',
                                style: const TextStyle(
                                  color: BColors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                )),
                            TextSpan(
                              text: labProvider.labList[index].address ??
                                  'No Address',
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: BColors.black),
                            )
                          ])))
                ],
              ),
              const Divider()
            ],
          ),
        ),
      );
    });
  }
}
