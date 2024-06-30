import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_container.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';

class ProductShowContainer extends StatelessWidget {
  const ProductShowContainer({
    super.key,
    required this.orderData,
  });

  final PharmacyOrderModel orderData;

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
        itemCount: orderData.productDetails?.length,
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
                      orderData.productDetails?[index].productData
                              ?.productName ??
                          'Unknown Product',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: BColors.black,
                    ),
                        
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: QuantitiyBox(
                      productQuantity:
                          '${orderData.productDetails?[index].quantity ?? '0'}',
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
