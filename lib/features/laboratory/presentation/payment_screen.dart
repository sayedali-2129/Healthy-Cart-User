import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/notifications/presentation/widgets/selected_tests_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class LabPaymentScreen extends StatelessWidget {
  const LabPaymentScreen({super.key});

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
          'Payment',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        shadowColor: BColors.black.withOpacity(0.8),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
                          text: const TextSpan(children: [
                            TextSpan(
                                text: 'Angel Labs- ',
                                style: TextStyle(
                                  color: BColors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                )),
                            TextSpan(
                              text:
                                  'Kozhikode, Rose Dam, Near Police Station, Westham',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: BColors.black),
                            )
                          ])))
                ],
              ),
              const Gap(8),
              const Divider(),
              const Gap(8),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return SelectedTestsCard(
                      index: index,
                      testName: 'Blood Test',
                      testPrice: '500',
                      offerPrice: '400',
                      image:
                          'https://www.eehealth.org/-/media/images/modules/blog/posts/2020/11/lab-tests.jpg',
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
