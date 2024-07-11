import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/pharmacy/application/pharmacy_order_provider.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_order_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/pharmacy_owner_model.dart';
import 'package:healthy_cart_user/features/pharmacy/domain/model/product_quantity_model.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/pharmacy_detail_container.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/product_details_page_view.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class ApprovedOrderDetailsScreen extends StatelessWidget {
  const ApprovedOrderDetailsScreen({
    super.key,
    required this.orderData,
  });

  final PharmacyOrderModel orderData;

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyOrderProvider>(
        builder: (context, orderProvider, _) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
                title: 'Order Details',
                onBackTap: () {
                  EasyNavigation.pop(context: context);
                }),
            SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Order ID -",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat'),
                              ),
                              const Gap(16),
                              GestureDetector(
                                onTap: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: orderData.id ?? ''));
                                  CustomToast.sucessToast(
                                      text: 'Order ID sucessfully copied.');
                                },
                                child: Container(
                                  height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: BColors.darkblue),
                                  child: Center(
                                    child: Text(
                                      '${orderData.id}',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: BColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          const Divider(),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ProductDetailsWidget(
                                index: index,
                                productData: orderData.productDetails?[index] ??
                                    ProductAndQuantityModel(),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: orderData.productDetails?.length ?? 0,
                          ),
                          const Divider(),
                          const Gap(12),
                          Column(
                            children: [
                              const Divider(),
                              (orderData.addresss != null &&
                                      orderData.deliveryType == orderProvider.homeDelivery)
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            '${orderData.pharmacyDetails?.pharmacyName ?? 'Pharmacy'}-${orderData.pharmacyDetails?.pharmacyAddress ?? 'Pharmacy'}',
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
                          (orderData.rejectReason == null ||
                                  orderData.rejectReason!.isEmpty)
                              ? const SizedBox()
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: BColors.mainlightColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Change reason :',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                color: BColors.textLightBlack,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                      ),
                                      const Gap(6),
                                      Text(
                                        orderData.rejectReason ??
                                            'Unknown reason',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 2,
                                fit: FlexFit.loose,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RowTextContainerWidget(
                                      text1: 'Delivery :',
                                      text2: orderProvider.deliveryType(
                                          orderData.deliveryType ?? ''),
                                      text1Color: BColors.textLightBlack,
                                      fontSizeText1: 12,
                                      fontSizeText2: 12,
                                      fontWeightText1: FontWeight.w600,
                                      text2Color: BColors.black,
                                    ),
                                    const Gap(8),
                                    (orderData.prescription != null &&
                                            orderData.prescription!.isNotEmpty)
                                        ? const Column(
                                            children: [
                                              RowTextContainerWidget(
                                                text1: 'Prescription :',
                                                text2: 'Included',
                                                text1Color:
                                                    BColors.textLightBlack,
                                                fontSizeText1: 12,
                                                fontSizeText2: 12,
                                                fontWeightText1:
                                                    FontWeight.w600,
                                                text2Color: BColors.black,
                                              ),
                                              Gap(8),
                                            ],
                                          )
                                        : const SizedBox(),
                                    RowTextContainerWidget(
                                      text1: 'Total Items Rate :',
                                      text2: "₹ ${orderData.totalAmount}",
                                      text1Color: BColors.textLightBlack,
                                      fontSizeText1: 12,
                                      fontSizeText2: 12,
                                      fontWeightText1: FontWeight.w600,
                                      text2Color: BColors.textBlack,
                                    ),
                                    const Gap(8),
                                    RowTextContainerWidget(
                                      text1: 'Total Discount :',
                                      text2:
                                          "- ₹ ${orderData.totalAmount ?? 0 - orderData.totalDiscountAmount!}",
                                      text1Color: BColors.textLightBlack,
                                      fontSizeText1: 12,
                                      fontSizeText2: 12,
                                      fontWeightText1: FontWeight.w600,
                                      text2Color: BColors.green,
                                    ),
                                    if (orderData.deliveryType == orderProvider.homeDelivery)
                                      Column(
                                        children: [
                                          const Gap(8),
                                          RowTextContainerWidget(
                                            text1: 'Delivery Charge :',
                                            text2: (orderData.deliveryCharge ==
                                                        0 ||
                                                    orderData.deliveryCharge ==
                                                        null)
                                                ? "Free Delivery"
                                                : '₹ ${orderData.deliveryCharge}',
                                            text1Color: BColors.textLightBlack,
                                            fontSizeText1: 12,
                                            fontSizeText2: 12,
                                            fontWeightText1: FontWeight.w600,
                                            text2Color: (orderData
                                                            .deliveryCharge ==
                                                        0 ||
                                                    orderData.deliveryCharge ==
                                                        null)
                                                ? BColors.green
                                                : BColors.textBlack,
                                          ),
                                          const Gap(8),
                                        ],
                                      ),
                                    const Divider(),
                                    RowTextContainerWidget(
                                      text1: 'Amount To Be Paid : ',
                                      text2: "₹ ${orderData.finalAmount}",
                                      text1Color: BColors.textBlack,
                                      fontSizeText1: 13,
                                      fontSizeText2: 14,
                                      fontWeightText1: FontWeight.w600,
                                      text2Color: BColors.green,
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(12),
                            ],
                          ),
                          const Divider(),
                          if (orderData.prescription != null &&
                              orderData.prescription!.isNotEmpty)
                            const Gap(12),
                          PharmacyDetailsContainer(
                            pharmacyData:
                                orderData.pharmacyDetails ?? PharmacyModel(),
                          ),
                          const Gap(12),
                          const Divider(),
                          const Text(
                            "Select A Payment Method",
                            style: TextStyle(
                                fontSize: 14,
                                color: BColors.textLightBlack,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                          const Gap(8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioMenuButton(
                                value: orderProvider.cashOnDelivery,
                                groupValue: orderProvider.selectedPaymentRadio,
                                onChanged: (value) {
                                  orderProvider.setSelectedRadio(value);
                                },
                                child: const Text(
                                  'Cash On Delivery',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              RadioMenuButton(
                                value: orderProvider.onlinePayment,
                                groupValue: orderProvider.selectedPaymentRadio,
                                onChanged: (value) {
                                  orderProvider.setSelectedRadio(value);
                                },
                                child: const Text(
                                  'Online Payment',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const Gap(16),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            if (orderProvider.selectedPaymentRadio == null) {
              CustomToast.errorToast(text: 'Please select a payment method.');
              return;
            }
            LoadingLottie.showLoading(context: context, text: 'Please wait...');
            orderProvider.updateOrderCompleteDetails(
                productData: orderData, context: context);
          },
          child: Container(
            height: 60,
            color: BColors.mainlightColor,
            child: const Center(
              child: Text(
                'Proceed With Payment',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: BColors.white),
              ),
            ),
          ),
        ),
      );
    });
  }
}
