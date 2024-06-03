import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_failure.freezed.dart';

@freezed
class MainFailure with _$MainFailure {
  const factory MainFailure.invalidPhoneNumber({required String errMsg}) =
      _InvalidPhoneNumber;
  const factory MainFailure.invalidOTP({required String errMsg}) = _InvalidOTP;
  const factory MainFailure.locationError({required String errMsg}) = _LocationError;
  const factory MainFailure.firebaseException({required String errMsg}) = _FirebaseExcep;  
  const factory MainFailure.generalException({required String errMsg}) = _GeneralException;  
}
