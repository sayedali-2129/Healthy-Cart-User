import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
import 'package:healthy_cart_user/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthy_cart_user/core/custom/custom_textfields/textfield_widget.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_lottie.dart';
import 'package:healthy_cart_user/core/custom/order_request/order_request_success.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/hospital/application/provider/hospital_provider.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/doctor_model.dart';
import 'package:healthy_cart_user/features/hospital/domain/models/hospital_model.dart';
import 'package:healthy_cart_user/features/profile/application/provider/user_family_provider.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_family_model.dart';
import 'package:healthy_cart_user/features/profile/presentation/widgets/member_card.dart';
import 'package:healthy_cart_user/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PatientMemberScreen extends StatefulWidget {
  const PatientMemberScreen({
    super.key,
    required this.selectedDoctor,
    required this.hospital,
  });
  final DoctorModel selectedDoctor;
  final HospitalModel hospital;
  @override
  State<PatientMemberScreen> createState() => _PatientMemberScreenState();
}

class _PatientMemberScreenState extends State<PatientMemberScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final familyMemberProvider = context.read<UserFamilyMembersProvider>();
      final authProvider = context.read<AuthenticationProvider>();
      familyMemberProvider.getUserFamilyMember(
          userId: authProvider.userFetchlDataFetched!.id!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final familyMemberProvider =
        Provider.of<UserFamilyMembersProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final hospitalProvider = Provider.of<HospitalProvider>(context);
    return Scaffold(
      body: PopScope(
        onPopInvoked: (didPop) {},
        child: CustomScrollView(
          slivers: [
            SliverCustomAppbar(
              title: 'Family Members',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              },
            ),
            if (familyMemberProvider.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: LoadingIndicater(),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Member",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'),
                      ),
                      const Gap(16),
                      const Divider(),
                      FadeInRight(child: const MembersCard()),
                      const Divider(),
                      const Gap(16),
                  TextfieldWidget(
                    keyboardType: TextInputType.emailAddress,
                    fieldHeading: 'UHID of patient in this hospital below',
                    hintText: 'Enter UHID(Optional)',
                    controller: hospitalProvider.uhidController,
                  ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (familyMemberProvider.selectedFamilyMember == null) {
            CustomToast.infoToast(text: 'Please add the pateint details');
            return;
          }
          ConfirmAlertBoxWidget.showAlertConfirmBox(
            context: context,
            titleText: 'Confirm Booking',
            subText:
                "Tap 'Yes' to send this booking to the Hospital to check the availability of the slot. Are you sure you want to proceed?",
            confirmButtonTap: () async {
              LoadingLottie.showLoading(
                  context: context, text: 'Please wait...');
              await hospitalProvider
                  .addHospitalBooking(
                      fcmtoken: widget.hospital.fcmToken ?? '',
                      userName: authProvider.userFetchlDataFetched!.userName!,
                      hospitalId: widget.hospital.id ?? '',
                      userId: authProvider.userFetchlDataFetched!.id!,
                      userModel: authProvider.userFetchlDataFetched!,
                      hospitalModel: widget.hospital,
                      totalAmount: widget.selectedDoctor.doctorFee!,
                      selectedDoctor: widget.selectedDoctor,
                      selectedMember:
                          familyMemberProvider.selectedFamilyMember ??
                              UserFamilyMembersModel())
                  .whenComplete(
                () {
                  EasyNavigation.pushAndRemoveUntil(
                    context: context,
                    type: PageTransitionType.bottomToTop,
                    page: const OrderRequestSuccessScreen(
                      title:
                          'Your Hospital appointment is currently being processed. We will notify you once its confirmed',
                    ),
                  );
                  hospitalProvider.clearControllerData();
                },
              );
            },
          );
        },
        child: Container(
            height: 60,
            color: BColors.mainlightColor,
            child: const Center(
              child: Text(
                'Check Availability',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: BColors.white),
              ),
            )),
      ),
    );
  }
}
