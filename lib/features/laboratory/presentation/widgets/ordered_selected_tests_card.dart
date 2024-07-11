import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_orders_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class OrderedSelectedTestsCard extends StatelessWidget {
  const OrderedSelectedTestsCard({
    super.key,
    required this.orderData,
  });

  final LabOrdersModel orderData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(8)),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: 6,
          right: 8,
          top: 8,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderData.selectedTest?.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      orderData.selectedTest?[index].testName ??
                          'Unknown Product',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: BColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(6),
            ],
          );
        },
      ),
    );
  }
}
