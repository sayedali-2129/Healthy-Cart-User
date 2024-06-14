import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/button_widget/button_widget.dart';
import 'package:healthy_cart_user/core/general/cached_network_image.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/payment_screen.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LabOrdersScreen extends StatefulWidget {
  const LabOrdersScreen({super.key});

  @override
  State<LabOrdersScreen> createState() => _LabOrdersScreenState();
}

class _LabOrdersScreenState extends State<LabOrdersScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<LabOrdersProvider>().getLabOrder();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
                title: 'Lab Orders', onBackTap: () => Navigator.pop(context)),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(12),
                itemCount: ordersProvider.ordersList.length,
                itemBuilder: (context, index) {
                  final orders = ordersProvider.ordersList[index];
                  return Container(
                    width: screenWidth,
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
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
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
                                    Text(
                                      'Blood Test & 2 Others',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: const Icon(
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
                                                      text: orders.labDetails!
                                                          .laboratoryName,
                                                      style: const TextStyle(
                                                        color: BColors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Montserrat',
                                                      )),
                                                  TextSpan(
                                                    text: orders
                                                        .labDetails!.address,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: BColors.black),
                                                  )
                                                ])))
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlineButtonWidget(
                                buttonHeight: 35,
                                buttonWidth: 140,
                                buttonColor: BColors.white,
                                borderColor: BColors.black,
                                buttonWidget: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: BColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {},
                              ),
                              ButtonWidget(
                                buttonHeight: 35,
                                buttonWidth: 140,
                                buttonColor: BColors.buttonGreen,
                                buttonWidget: Text(
                                  'Accept',
                                  style: TextStyle(
                                      color: BColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  EasyNavigation.push(
                                      context: context,
                                      type: PageTransitionType.fade,
                                      duration: 200,
                                      page: LabPaymentScreen());
                                },
                              ),
                            ],
                          ),
                          const Gap(10),
                          Column(
                            children: [
                              Text(
                                'Laboratory will reach you on :',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const Gap(5),
                              Text(
                                '27/10/2024 1.00 PM - 2.00 PM',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
