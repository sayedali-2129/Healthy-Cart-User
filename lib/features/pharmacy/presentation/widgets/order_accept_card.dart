import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/textfield_alertbox.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
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
              if(onProcessOrderData.isUserAccepted == true)
              Text(
                'Your order is on processing...',
                style: TextStyle(
                    color: BColors.mainlightColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
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
                    if (onProcessOrderData.deliveryType == 'Home')
                      RowTextContainerWidget(
                        text1: 'Delivery charge : ',
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
                    const Gap(8),
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
                    if (onProcessOrderData.deliveryType == 'Home')
                      Column(children: [
                        const Gap(8),
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'All charges included.',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 10,
                            color: BColors.textLightBlack,
                            fontWeight: FontWeight.w500),
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
                          onProcessOrderData.deliveryType == "Home")
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Address : ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: BColors.textLightBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
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
                            Text(
                              'Pick-Up Address : ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: BColors.textLightBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                '${onProcessOrderData.pharmacyDetails?.pharmacyName ?? 'Pharmacy'}-${onProcessOrderData.pharmacyDetails?.pharmacyAddress ?? 'Pharmacy'}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        color: BColors.textBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
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
              if(onProcessOrderData.isUserAccepted != true)
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
                            confirmButtonTap: () {
                              orderProvider.rejectionReasonController.clear();
                              TextFieldAlertBoxWidget.showAlertTextFieldBox(
                                context: context,
                                controller:
                                    orderProvider.rejectionReasonController,
                                maxlines: 3,
                                hintText:
                                    'Let us know more about cancellation.',
                                titleText: 'Confrim to cancel !',
                                subText:
                                    'Are you sure you want to cancel this order?',
                                confirmButtonTap: () {
                                  LoadingLottie.showLoading(
                                      context: context, text: 'Cancelling...');
                                  orderProvider
                                      .cancelPharmacyApprovedOrder(
                                          orderData: onProcessOrderData)
                                      .whenComplete(
                                          () => Navigator.pop(context));
                                },
                              );
                            },
                            titleText: 'Confirm To Cancel !',
                            hintText: 'Let us know the reason for cancellation',
                            subText:
                                'Are you sure you want to confirm the cancellation of this order?',
                            controller: orderProvider.rejectionReasonController,
                            maxlines: 3);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(),
                              borderRadius: BorderRadius.circular(8))),
                      child: Text('Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
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
                      child: Text('Proceed',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
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
