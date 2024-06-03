import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/features/user_profile/domain/model/user_model.dart';

abstract class IAuthFacade {
  //factory IAuthFacade() => IAuthImpl(FirebaseAuth.instance);
  Stream<Either<MainFailure, bool>> verifyPhoneNumber(String phoneNumber);
  Future<Either<MainFailure, String>> verifySmsCode({
    required String smsCode,
  });

  Stream<Either<MainFailure, UserModel>> userStreamFetchData(String userId);

  Future<Either<MainFailure, String>> userLogOut();
  Future<void> cancelStream();
}
