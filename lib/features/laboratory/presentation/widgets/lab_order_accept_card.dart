import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/launch_dialer.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/payment_screen.dart';
import 'package:healthy_cart_user/features/pharmacy/presentation/widgets/row_text_widget.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AcceptCard extends StatefulWidget {
  const AcceptCard({
    super.key,
    required this.screenWidth,
    required this.index,
  });

  final double screenWidth;
  final int index;

  @override
  State<AcceptCard> createState() => _AcceptCardState();
}

class _AcceptCardState extends State<AcceptCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      final orders = ordersProvider.approvedOrders[widget.index];
      return Container(
        width: widget.screenWidth,
        decoration: BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: BColors.black.withOpacity(0.3),
              blurRadius: 5,
            ),
          ],
        ),
        child:
            //MAIN COLUMN
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 70,
                      width: 70,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: CustomCachedNetworkImage(
                          image: orders.labDetails!.image!)),
                  const Gap(20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Your Booking is Success',
                              style: TextStyle(
                                  color: BColors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Gap(5),
                            Icon(
                              Icons.check_circle_rounded,
                              color: BColors.green,
                              size: 18,
                            )
                          ],
                        ),
                        const Divider(),
                        orders.selectedTest!.length == 1
                            ? Text(orders.selectedTest!.first.testName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15))
                            : Text(
                                '${orders.selectedTest!.first.testName!} & ${orders.selectedTest!.length - 1} More',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 15,
                              ),
                            ),
                            // const Gap(5),
                            Expanded(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: orders.labDetails!.laboratoryName,
                                      style: const TextStyle(
                                        color: BColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                      )),
                                  TextSpan(
                                    text: orders.labDetails!.address,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: BColors.black),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              (orders.tokenNumber != null)
                  ? Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: BColors.offRed),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Token No- ${orders.tokenNumber}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: Colors.white,
                                  )),
                        ),
                      ),
                    )
                  : const SizedBox(),
              if (orders.notes != null && orders.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(color: BColors.mainlightColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: RowTextContainerWidget(
                        text1: 'Note by laboratory : ',
                        text2: orders.notes ?? 'Unknown note',
                        text1Color: BColors.textLightBlack,
                        fontSizeText1: 12,
                        fontSizeText2: 13,
                        fontWeightText1: FontWeight.w600,
                        text2Color: BColors.black),
                  ),
                ),
              const Gap(8),
              orders.isUserAccepted == false
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlineButtonWidget(
                              buttonHeight: 35,
                              buttonWidth: 140,
                              buttonColor: BColors.white,
                              borderColor: BColors.black,
                              buttonWidget: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                ConfirmAlertBoxWidget.showAlertConfirmBox(
                                  context: context,
                                  titleSize: 18,
                                  titleText: 'Cancel',
                                  subText:
                                      'Are you sure you want to cancel this order?',
                                  confirmButtonTap: () async {
                                    LoadingLottie.showLoading(
                                        context: context,
                                        text: 'Cancelling...');
                                    await ordersProvider
                                        .cancelOrder(
                                      fromPending: false,
                                      fcmtoken:
                                          orders.labDetails!.fcmToken ?? '',
                                      userName: orders.userDetails!.userName ??
                                          'User',
                                      orderId: orders.id!,
                                    )
                                        .whenComplete(
                                      () {
                                        ordersProvider.singleOrderDoc = null;

                                        EasyNavigation.pop(context: context);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            ButtonWidget(
                              buttonHeight: 35,
                              buttonWidth: 140,
                              buttonColor: BColors.buttonGreen,
                              buttonWidget: const Text(
                                'Accept',
                                style: TextStyle(
                                    color: BColors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.fade,
                                    page: LabPaymentScreen(
                                      labOrdersModel: orders,
                                    ));
                              },
                            ),
                          ],
                        ),
                        const Gap(10),
                        orders.usertimeSlot != null
                            ? Column(
                                children: [
                                  Text(
                                    (orders.testMode == 'Home')
                                        ? 'Our assistant will reach you at :'
                                        : 'Your booking has been scheduled to :',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Gap(5),
                                  Text(
                                    (orders.admintimeSlot != null &&
                                            orders.admintimeSlot!.isNotEmpty)
                                        ? '${orders.admintimeSlot}'
                                        : '${orders.usertimeSlot}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  )
                                ],
                              )
                            : const Gap(0),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          'Your Test is on Processing...',
                          style: TextStyle(
                              color: Color(0xffEB9025),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        const Gap(10),
                        OutlineButtonWidget(
                            onPressed: () async {
                              await LaunchDialer.lauchDialer(
                                  phoneNumber: '${orders.labDetails?.contactNumber ?? orders.labDetails?.phoneNo}');
                            },
                            borderColor: BColors.black,
                            buttonHeight: 38,
                            buttonWidth: 140,
                            buttonColor: BColors.white,
                            buttonWidget: const Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  color: BColors.black,
                                  size: 18,
                                ),
                                Gap(10),
                                Text(
                                  'Call Lab',
                                  style: TextStyle(
                                      color: BColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ))
                      ],
                    ),
            ],
          ),
        ),
      );
    });
  }
}
