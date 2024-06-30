import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyDetailsContainer extends StatelessWidget {
  const PharmacyDetailsContainer({
    super.key,
    required this.pharmacyData,
  });
  final PharmacyModel pharmacyData;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<PharmacyOrderProvider>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pharmacyData.pharmacyName ?? 'Unknown Pharmacy',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BColors.textBlack),
            ),
            const Gap(4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowTwoTextWidget(
                            text1: 'Address :',
                            text2: pharmacyData.pharmacyAddress ??
                                'Unknown Address',
                            gap: 8),
                        const Gap(4),
                        RowTwoTextWidget(
                            text1: 'Phone No :',
                            text2: pharmacyData.phoneNo ?? 'Unknown PhoneNo',
                            gap: 8),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // PhysicalModel(
                      //   elevation: 2,
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(16),
                      //   child: SizedBox(
                      //     width: 40,
                      //     height: 40,
                      //     child: Center(
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(
                      //           Icons.location_on_sharp,
                      //           size: 24,
                      //           color: Colors.blue,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Gap(12),
                      PhysicalModel(
                        elevation: 2,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                orderProvider.lauchDialer(
                                    phoneNumber: pharmacyData.phoneNo ?? '');
                              },
                              icon: const Icon(Icons.phone,
                                  size: 24, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RowTwoTextWidget extends StatelessWidget {
  const RowTwoTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.gap,
  });
  final String text1;
  final String text2;
  final double gap;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BColors.textLightBlack),
        ),
        Gap(gap),
        Expanded(
          child: Text(
            text2,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BColors.black),
          ),
        ),
      ],
    );
  }
}
