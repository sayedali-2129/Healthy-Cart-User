import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/textfield_alertbox.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/timeline_indicator/timeline_indicator.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/address_card.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/approved_details_view_page.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/date_and_order_id.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_detail_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/quantity_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PharmacyAcceptedCard extends StatelessWidget {
  const PharmacyAcceptedCard({super.key, required this.onProcessOrderData});
  final PharmacyOrderModel onProcessOrderData;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<PharmacyOrderProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6.0,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderIDAndDateSection(
                orderData: onProcessOrderData,
                date: orderProvider
                    .dateFromTimeStamp(onProcessOrderData.acceptedAt!),
              ),
              const Gap(8),
              if (onProcessOrderData.isUserAccepted == true &&
                  onProcessOrderData.isOrderPacked == false)
                Text(
                  'Your order is on processing...',
                  style: TextStyle(
                      color: BColors.mainlightColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                )
              else if (onProcessOrderData.isOrderPacked == true)
                Text(
                  'Getting ready for delivery...',
                  style: TextStyle(
                      color: BColors.mainlightColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                )
              else
                const SizedBox(),
              const Gap(12),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 6,
                        right: 8,
                        top: 8,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: onProcessOrderData.productDetails?.length,
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
                                      onProcessOrderData.productDetails?[index]
                                              .productData?.productName ??
                                          'Unknown Product',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: BColors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12)),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: QuantitiyBox(
                                    productQuantity:
                                        '${onProcessOrderData.productDetails?[index].quantity ?? '0'}',
                                  ),
                                ),
                              ],
                            ),
                            const Gap(6),
                          ],
                        );
                      },
                    ),
                    const Gap(8)
                  ],
                ),
              ),
              const Gap(8),
              if (onProcessOrderData.isUserAccepted ?? false)
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TimeLineOrderStatus(
                        isFirst: true,
                        isLast: false,
                        isPast: onProcessOrderData.isUserAccepted ?? false,
                        icon: Icons.lock_clock,
                        text: 'Processing',
                        height: 32,
                        widthOfLine: 120,
                      ),
                      TimeLineOrderStatus(
                          isFirst: false,
                          isLast: false,
                          isPast: onProcessOrderData.isOrderPacked ?? false,
                          icon: Icons.card_giftcard,
                          text: 'Packed',
                          height: 32,
                          widthOfLine: 120),
                      TimeLineOrderStatus(
                        isFirst: false,
                        isLast: true,
                        isPast: onProcessOrderData.isOrderDelivered ?? false,
                        icon: Icons.local_shipping,
                        text: 'Delivered',
                        height: 32,
                        widthOfLine: 120,
                      )
                    ],
                  ),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowTextContainerWidget(
                      text1: 'Delivery : ',
                      text2: orderProvider
                          .deliveryType(onProcessOrderData.deliveryType ?? ''),
                      text1Color: BColors.textLightBlack,
                      fontSizeText1: 12,
                      fontSizeText2: 12,
                      fontWeightText1: FontWeight.w600,
                      text2Color: BColors.green,
                    ),
                    const Gap(4),
                    RowTextContainerWidget(
                      text1: 'Total Items Rate :',
                      text2: "₹ ${onProcessOrderData.totalAmount}",
                      text1Color: BColors.textLightBlack,
                      fontSizeText1: 12,
                      fontSizeText2: 12,
                      fontWeightText1: FontWeight.w600,
                      text2Color: BColors.textBlack,
                    ),
                    const Gap(4),
                    if (onProcessOrderData.totalDiscountAmount != null)
                      RowTextContainerWidget(
                        text1: 'Total Discount :',
                        text2:
                            "- ₹ ${onProcessOrderData.totalAmount! - onProcessOrderData.totalDiscountAmount!}",
                        text1Color: BColors.textLightBlack,
                        fontSizeText1: 12,
                        fontSizeText2: 12,
                        fontWeightText1: FontWeight.w600,
                        text2Color: BColors.green,
                      ),
                    const Gap(4),
                    if (onProcessOrderData.deliveryType == orderProvider.homeDelivery)
                      Column(children: [
                        RowTextContainerWidget(
                          text1: 'Delivery Charge :',
                          text2: (onProcessOrderData.deliveryCharge == 0 ||
                                  onProcessOrderData.deliveryCharge == null)
                              ? "Free Delivery"
                              : '₹ ${onProcessOrderData.deliveryCharge}',
                          text1Color: BColors.textLightBlack,
                          fontSizeText1: 12,
                          fontSizeText2: 12,
                          fontWeightText1: FontWeight.w600,
                          text2Color: (onProcessOrderData.deliveryCharge == 0 ||
                                  onProcessOrderData.deliveryCharge == null)
                              ? BColors.green
                              : BColors.textBlack,
                        ),
                      ]),
                    const Divider(),
                    RowTextContainerWidget(
                      text1: 'Amount To Be Paid :',
                      text2: '₹ ${onProcessOrderData.finalAmount}',
                      text1Color: BColors.textLightBlack,
                      fontSizeText1: 13,
                      fontSizeText2: 13,
                      fontWeightText1: FontWeight.w600,
                      text2Color: BColors.green,
                    ),
                    const Gap(4),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'All charges included.',
                        style: TextStyle(
                            fontSize: 10,
                            color: BColors.textLightBlack,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat'),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Column(
                children: [
                  const Divider(),
                  (onProcessOrderData.addresss != null &&
                          onProcessOrderData.deliveryType == orderProvider.homeDelivery )
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery Address : ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: BColors.textLightBlack,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat'),
                            ),
                            const Gap(8),
                            Expanded(
                              child: AddressOrderCard(
                                  addressData: onProcessOrderData.addresss!),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pick-Up Address : ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: BColors.textLightBlack,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat'),
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                '${onProcessOrderData.pharmacyDetails?.pharmacyName ?? 'Pharmacy'}-${onProcessOrderData.pharmacyDetails?.pharmacyAddress ?? 'Pharmacy'}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: BColors.textBlack,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat'),
                              ),
                            )
                          ],
                        ),
                  const Divider(),
                ],
              ),
              PharmacyDetailsContainer(
                pharmacyData:
                    onProcessOrderData.pharmacyDetails ?? PharmacyModel(),
              ),
              const Gap(16),
              if (onProcessOrderData.isUserAccepted != true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 136,
                      child: ElevatedButton(
                        onPressed: () {
                          TextFieldAlertBoxWidget.showAlertTextFieldBox(
                            context: context,
                            controller: orderProvider.rejectionReasonController,
                            maxlines: 3,
                            hintText:
                                'Let us know more about cancellation.(Optional)',
                            titleText: 'Confrim to cancel !',
                            subText:
                                'Are you sure you want to cancel this order?',
                            confirmButtonTap: () {
                              LoadingLottie.showLoading(
                                  context: context, text: 'Cancelling...');
                              orderProvider
                                  .cancelPharmacyApprovedOrder(
                                      orderData: onProcessOrderData)
                                  .whenComplete(() => Navigator.pop(context));
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(),
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 14,
                              color: BColors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 136,
                      child: ElevatedButton(
                        onPressed: () {
                          EasyNavigation.push(
                              context: context,
                              type: PageTransitionType.bottomToTop,
                              page: ApprovedOrderDetailsScreen(
                                  orderData: onProcessOrderData));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text(
                          'Proceed',
                          style: TextStyle(
                              fontSize: 14,
                              color: BColors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
