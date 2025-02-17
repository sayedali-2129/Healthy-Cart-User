import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/checkout_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_prescription_order_address_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/test_type_radio.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_address_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_address_model.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class LabDateBookingScreen extends StatelessWidget {
  const LabDateBookingScreen({
    super.key,
    required this.labModel,
    required this.user,
    required this.fromPrescription,
  });

  final LabModel labModel;
  final UserModel user;
  final bool fromPrescription;

  @override
  Widget build(BuildContext context) {
    return Consumer3<LabProvider, AuthenticationProvider, UserAddressProvider>(
        builder: (context, labProvider, authProvider, addressProvider, _) {
      return PopScope(
        onPopInvoked: (didPop) {
          labProvider.selectedTimeSlot1 = null;
          labProvider.selectedTimeSlot2 = null;
          labProvider.seletedBookingDate = null;
        },
        child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              backgroundColor: BColors.mainlightColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              title: const Text(
                'Booking',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(16),
                    const Text("Choose Date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    const Gap(16),
                    DatePicker(
                      DateTime.now(),
                      inactiveDates: labProvider.findAllSundaysFromNow(30),
                      deactivatedColor: BColors.red,
                      onDateChange: (selectedDate) {
                        final formattedDate =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                        labProvider.seletedBookingDate = formattedDate;
                      },
                      daysCount: 30,
                      initialSelectedDate: null,
                      selectionColor: BColors.mainlightColor,
                      height: 90,
                    ),
                    const Gap(16),
                    const Text("Choose Time",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimePickerSpinnerPopUp(
                          cancelTextStyle:
                              Theme.of(context).textTheme.labelLarge,
                          confirmTextStyle:
                              Theme.of(context).textTheme.labelLarge,
                          iconSize: 24,
                          timeFormat: 'hh:mm a',
                          use24hFormat: false,
                          mode: CupertinoDatePickerMode.time,
                          onChange: (dateTime) {
                            labProvider.selectedTimeSlot1 =
                                DateFormat.jm().format(dateTime);
                          },
                        ),
                        const Gap(8),
                        Text(
                          'To',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(8),
                        TimePickerSpinnerPopUp(
                          cancelTextStyle:
                              Theme.of(context).textTheme.labelLarge,
                          confirmTextStyle:
                              Theme.of(context).textTheme.labelLarge,
                          iconSize: 24,
                          timeFormat: 'hh:mm a',
                          use24hFormat: false,
                          mode: CupertinoDatePickerMode.time,
                          onChange: (dateTime) {
                            labProvider.selectedTimeSlot2 =
                                DateFormat.jm().format(dateTime);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: fromPrescription == false
                ? GestureDetector(
                    onTap: () {
                      if (labProvider.selectedTimeSlot1 == null ||
                          labProvider.selectedTimeSlot2 == null ||
                          labProvider.seletedBookingDate == null) {
                        CustomToast.infoToast(
                            text: 'Please select date and time');
                      } else {
                        labProvider.setTimeSlot();
                        EasyNavigation.push(
                          type: PageTransitionType.rightToLeft,
                          context: context,
                          page: CheckoutScreen(
                            userId: user.id ?? '',
                            labData: labModel,
                            userModel: user,
                          ),
                        );
                      }
                    },
                    child: Container(
                        height: 60,
                        color: BColors.mainlightColor,
                        child: const Center(
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: BColors.white,
                            ),
                          ),
                        )),
                  )
                : GestureDetector(
                    onTap: () {
                      if (labProvider.selectedTimeSlot1 == null ||
                          labProvider.selectedTimeSlot2 == null ||
                          labProvider.seletedBookingDate == null) {
                        CustomToast.infoToast(
                            text: 'Please select date and time');
                      } else {
                        labProvider.setTimeSlot();

                        showDialog(
                          context: context,
                          builder: (context) => TestTypeRadiopopup(
                            onConfirm: () {
                              if (labProvider.selectedRadio == 'Lab') {
                                ConfirmAlertBoxWidget.showAlertConfirmBox(
                                    context: context,
                                    titleText: 'Confirm Order',
                                    subText:
                                        'This will send your order to the laboratory and check the availability of the test. Are you sure you want to proceed?',
                                    confirmButtonTap: () async {
                                      LoadingLottie.showLoading(
                                          context: context,
                                          text: 'Please wait...');

                                      if (labProvider.prescriptionFile !=
                                          null) {
                                        await labProvider.uploadPrescription();
                                      }
                                      await labProvider
                                          .addLabOrders(
                                              prescriptionOnly: true,
                                              selectedTests: [],
                                              labModel: labModel,
                                              labId: labModel.id!,
                                              userId: authProvider
                                                  .userFetchlDataFetched!.id!,
                                              userModel: authProvider
                                                  .userFetchlDataFetched!,
                                              selectedAddress: addressProvider
                                                      .selectedAddress ??
                                                  UserAddressModel(),
                                              fcmtoken: labModel.fcmToken!,
                                              userName: authProvider
                                                  .userFetchlDataFetched!
                                                  .userName!)
                                          .whenComplete(
                                        () {
                                          labProvider.selectedRadio = null;
                                          addressProvider.selectedAddress =
                                              null;
                                          EasyNavigation.pushAndRemoveUntil(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            context: context,
                                            page:
                                                const OrderRequestSuccessScreen(
                                              title:
                                                  'Your Laboratory appointment is currently being processed. We will notify you once its confirmed',
                                            ),
                                          );
                                          labProvider.clearCurrentDetails();
                                        },
                                      );
                                    });
                              } else {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    page: LabPrescriptionOrderAddressScreen(
                                      labModel: labModel,
                                      userId: authProvider
                                              .userFetchlDataFetched!.id ??
                                          '',
                                    ));
                              }
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                        height: 60,
                        color: BColors.mainlightColor,
                        child: const Center(
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: BColors.white,
                            ),
                          ),
                        )),
                  )),
      );
    });
  }
}
