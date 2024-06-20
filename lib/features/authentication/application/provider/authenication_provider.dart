import 'package:flutter/material.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/domain/facade/i_auth_facade.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
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
  String? verificationId;
  String? smsCode;
  final TextEditingController phoneNumberController = TextEditingController();
  String? countryCode;
  String? phoneNumber;
  String? userId;
  // int? isRequsetedPendingPage;

  void setNumber() {
    phoneNumber = '$countryCode${phoneNumberController.text.trim()}';
    notifyListeners();
  }

  void userStreamFetchData(
      {required String userId, required BuildContext context}) {
    iAuthFacade.userStreamFetchData(userId).listen((event) {
      event.fold((failure) {}, (snapshot) {
        userFetchlDataFetched = snapshot;
        // isRequsetedPendingPage = snapshot.requested;
        notifyListeners();
      });
    });
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
        notifyListeners();
      });
    });
    return result;
  }

  void navigationUserFuction({required BuildContext context}) async {
    // if (userFetchlDataFetched?.address == null ||
    //     userFetchlDataFetched?.image == null ||
    //     userFetchlDataFetched?.laboratoryName == null ||
    //     userFetchlDataFetched?.uploadLicense == null ||
    //     userFetchlDataFetched?.ownerName == null) {
    //   EasyNavigation.pushReplacement(
    //     type: PageTransitionType.bottomToTop,
    //     context: context,
    //     page:
    //         LaboratoryFormScreen(phoneNo: userFetchlDataFetched?.phoneNo ?? ''),
    //   );
    //   notifyListeners();
    // } else if (userFetchlDataFetched?.placemark == null) {
    //   EasyNavigation.pushReplacement(
    //     type: PageTransitionType.bottomToTop,
    //     context: context,
    //     page: const LocationPage(),
    //   );
    //   notifyListeners();
    // }  else {
    EasyNavigation.pushAndRemoveUntil(
        type: PageTransitionType.bottomToTop,
        context: context,
        page: const LoginScreen());
    notifyListeners();
  }

  void verifyPhoneNumber({required BuildContext context}) {
    iAuthFacade.verifyPhoneNumber(phoneNumber!).listen((result) {
      result.fold((failure) {
        Navigator.pop(context);
        CustomToast.errorToast(text: failure.errMsg);
      }, (isVerified) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => OTPScreen(
                      verificationId: verificationId ?? 'No veriId',
                      phoneNumber: phoneNumber ?? 'No Number',
                    ))));
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
      EasyNavigation.pushReplacement(
          context: context, page: const SplashScreen());
    });
  }

  Future<void> userLogOut({required BuildContext context}) async {
    final result = await iAuthFacade.userLogOut();
    result.fold((failure) {
      Navigator.pop(context);
      CustomToast.errorToast(text: failure.errMsg);
    }, (sucess) {
      Navigator.pop(context);
      CustomToast.sucessToast(text: sucess);
      EasyNavigation.pushReplacement(
          context: context, page: const SplashScreen());
    });
  }
}
