import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/custom/user_block_alert_dialogur.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/domain/facade/i_auth_facade.dart';
import 'package:healthy_cart_user/features/authentication/presentation/otp_ui.dart';
import 'package:healthy_cart_user/features/profile/domain/models/user_model.dart';
import 'package:healthy_cart_user/features/splash_screen/splash_screen.dart';
import 'package:injectable/injectable.dart';
import 'package:page_transition/page_transition.dart';

@injectable
class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider(this.iAuthFacade);
  final IAuthFacade iAuthFacade;
  UserModel? userFetchlDataFetched;
  String? smsCode;
  final TextEditingController phoneNumberController = TextEditingController();
  String? countryCode;
  String? phoneNumber;
  String? userId;
  // int? isRequsetedPendingPage;
  final auth = FirebaseAuth.instance;
  void setNumber() {
    phoneNumber = '$countryCode${phoneNumberController.text.trim()}';
    notifyListeners();
  }

  bool userStreamFetchedData({required String userId}) {
    bool result = false;
    iAuthFacade.userStreamFetchData(userId).listen((event) {
      event.fold((failure) {
        result = false;
      }, (snapshot) {
        userFetchlDataFetched = snapshot;
        // isRequsetedPendingPage = snapshot.requested;
        result = true;
        if (snapshot.isActive == false) {
          UserBlockedAlertBox.userBlockedAlert();
        }
        notifyListeners();
      });
    });
    return result;
  }

  void navigationUserFuction({required BuildContext context}) async {

    EasyNavigation.pushAndRemoveUntil(
        type: PageTransitionType.bottomToTop,
        context: context,
        page: const BottomNavigationWidget());
    notifyListeners();
  }

  void verifyPhoneNumber({required BuildContext context,  bool? resend}) {
    iAuthFacade.verifyPhoneNumber(phoneNumber!).listen((result) {
      result.fold((failure) {
        Navigator.pop(context);
        CustomToast.errorToast(text: failure.errMsg);
      }, (isVerified) {
        Navigator.pop(context);
        if(resend == false){
          EasyNavigation.push(
            type: PageTransitionType.rightToLeft,
            context: context,
            page: OTPScreen(
              phoneNumber: phoneNumber ?? 'No Number',
            ),);
        }
 
      });
    });
  }

  Future<void> verifySmsCode(
      {required String smsCode, required BuildContext context}) async {
    final result = await iAuthFacade.verifySmsCode(smsCode: smsCode);
    result.fold((failure) {
      Navigator.pop(context);
      CustomToast.errorToast(text: failure.errMsg);
    }, (userId) {
      userId = userId;
      Navigator.pop(context);
      EasyNavigation.pushAndRemoveUntil(context: context, page: const SplashScreen());
    });
  }

  Future<void> userLogOut({required BuildContext context}) async {
    final result = await iAuthFacade.userLogOut();
    result.fold((failure) {
      Navigator.pop(context);
      CustomToast.errorToast(text: failure.errMsg);
    }, (sucess) {
      Navigator.pop(context);
      userFetchlDataFetched = null;
      CustomToast.sucessToast(text: sucess);
      EasyNavigation.pushReplacement(
          context: context, page: const SplashScreen());
    });
  } 


}
