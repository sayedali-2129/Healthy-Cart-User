// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MainFailure {
  String get errMsg => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String errMsg) invalidPhoneNumber,
    required TResult Function(String errMsg) invalidOTP,
    required TResult Function(String errMsg) locationError,
    required TResult Function(String errMsg) firebaseException,
    required TResult Function(String errMsg) generalException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String errMsg)? invalidPhoneNumber,
    TResult? Function(String errMsg)? invalidOTP,
    TResult? Function(String errMsg)? locationError,
    TResult? Function(String errMsg)? firebaseException,
    TResult? Function(String errMsg)? generalException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String errMsg)? invalidPhoneNumber,
    TResult Function(String errMsg)? invalidOTP,
    TResult Function(String errMsg)? locationError,
    TResult Function(String errMsg)? firebaseException,
    TResult Function(String errMsg)? generalException,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidPhoneNumber value) invalidPhoneNumber,
    required TResult Function(_InvalidOTP value) invalidOTP,
    required TResult Function(_LocationError value) locationError,
    required TResult Function(_FirebaseExcep value) firebaseException,
    required TResult Function(_GeneralException value) generalException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult? Function(_InvalidOTP value)? invalidOTP,
    TResult? Function(_LocationError value)? locationError,
    TResult? Function(_FirebaseExcep value)? firebaseException,
    TResult? Function(_GeneralException value)? generalException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult Function(_InvalidOTP value)? invalidOTP,
    TResult Function(_LocationError value)? locationError,
    TResult Function(_FirebaseExcep value)? firebaseException,
    TResult Function(_GeneralException value)? generalException,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MainFailureCopyWith<MainFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainFailureCopyWith<$Res> {
  factory $MainFailureCopyWith(
          MainFailure value, $Res Function(MainFailure) then) =
      _$MainFailureCopyWithImpl<$Res, MainFailure>;
  @useResult
  $Res call({String errMsg});
}

/// @nodoc
class _$MainFailureCopyWithImpl<$Res, $Val extends MainFailure>
    implements $MainFailureCopyWith<$Res> {
  _$MainFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = null,
  }) {
    return _then(_value.copyWith(
      errMsg: null == errMsg
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvalidPhoneNumberImplCopyWith<$Res>
    implements $MainFailureCopyWith<$Res> {
  factory _$$InvalidPhoneNumberImplCopyWith(_$InvalidPhoneNumberImpl value,
          $Res Function(_$InvalidPhoneNumberImpl) then) =
      __$$InvalidPhoneNumberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String errMsg});
}

/// @nodoc
class __$$InvalidPhoneNumberImplCopyWithImpl<$Res>
    extends _$MainFailureCopyWithImpl<$Res, _$InvalidPhoneNumberImpl>
    implements _$$InvalidPhoneNumberImplCopyWith<$Res> {
  __$$InvalidPhoneNumberImplCopyWithImpl(_$InvalidPhoneNumberImpl _value,
      $Res Function(_$InvalidPhoneNumberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = null,
  }) {
    return _then(_$InvalidPhoneNumberImpl(
      errMsg: null == errMsg
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InvalidPhoneNumberImpl implements _InvalidPhoneNumber {
  const _$InvalidPhoneNumberImpl({required this.errMsg});

  @override
  final String errMsg;

  @override
  String toString() {
    return 'MainFailure.invalidPhoneNumber(errMsg: $errMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidPhoneNumberImpl &&
            (identical(other.errMsg, errMsg) || other.errMsg == errMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidPhoneNumberImplCopyWith<_$InvalidPhoneNumberImpl> get copyWith =>
      __$$InvalidPhoneNumberImplCopyWithImpl<_$InvalidPhoneNumberImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String errMsg) invalidPhoneNumber,
    required TResult Function(String errMsg) invalidOTP,
    required TResult Function(String errMsg) locationError,
    required TResult Function(String errMsg) firebaseException,
    required TResult Function(String errMsg) generalException,
  }) {
    return invalidPhoneNumber(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String errMsg)? invalidPhoneNumber,
    TResult? Function(String errMsg)? invalidOTP,
    TResult? Function(String errMsg)? locationError,
    TResult? Function(String errMsg)? firebaseException,
    TResult? Function(String errMsg)? generalException,
  }) {
    return invalidPhoneNumber?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String errMsg)? invalidPhoneNumber,
    TResult Function(String errMsg)? invalidOTP,
    TResult Function(String errMsg)? locationError,
    TResult Function(String errMsg)? firebaseException,
    TResult Function(String errMsg)? generalException,
    required TResult orElse(),
  }) {
    if (invalidPhoneNumber != null) {
      return invalidPhoneNumber(errMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidPhoneNumber value) invalidPhoneNumber,
    required TResult Function(_InvalidOTP value) invalidOTP,
    required TResult Function(_LocationError value) locationError,
    required TResult Function(_FirebaseExcep value) firebaseException,
    required TResult Function(_GeneralException value) generalException,
  }) {
    return invalidPhoneNumber(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult? Function(_InvalidOTP value)? invalidOTP,
    TResult? Function(_LocationError value)? locationError,
    TResult? Function(_FirebaseExcep value)? firebaseException,
    TResult? Function(_GeneralException value)? generalException,
  }) {
    return invalidPhoneNumber?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult Function(_InvalidOTP value)? invalidOTP,
    TResult Function(_LocationError value)? locationError,
    TResult Function(_FirebaseExcep value)? firebaseException,
    TResult Function(_GeneralException value)? generalException,
    required TResult orElse(),
  }) {
    if (invalidPhoneNumber != null) {
      return invalidPhoneNumber(this);
    }
    return orElse();
  }
}

abstract class _InvalidPhoneNumber implements MainFailure {
  const factory _InvalidPhoneNumber({required final String errMsg}) =
      _$InvalidPhoneNumberImpl;

  @override
  String get errMsg;
  @override
  @JsonKey(ignore: true)
  _$$InvalidPhoneNumberImplCopyWith<_$InvalidPhoneNumberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidOTPImplCopyWith<$Res>
    implements $MainFailureCopyWith<$Res> {
  factory _$$InvalidOTPImplCopyWith(
          _$InvalidOTPImpl value, $Res Function(_$InvalidOTPImpl) then) =
      __$$InvalidOTPImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String errMsg});
}

/// @nodoc
class __$$InvalidOTPImplCopyWithImpl<$Res>
    extends _$MainFailureCopyWithImpl<$Res, _$InvalidOTPImpl>
    implements _$$InvalidOTPImplCopyWith<$Res> {
  __$$InvalidOTPImplCopyWithImpl(
      _$InvalidOTPImpl _value, $Res Function(_$InvalidOTPImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = null,
  }) {
    return _then(_$InvalidOTPImpl(
      errMsg: null == errMsg
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InvalidOTPImpl implements _InvalidOTP {
  const _$InvalidOTPImpl({required this.errMsg});

  @override
  final String errMsg;

  @override
  String toString() {
    return 'MainFailure.invalidOTP(errMsg: $errMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidOTPImpl &&
            (identical(other.errMsg, errMsg) || other.errMsg == errMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidOTPImplCopyWith<_$InvalidOTPImpl> get copyWith =>
      __$$InvalidOTPImplCopyWithImpl<_$InvalidOTPImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String errMsg) invalidPhoneNumber,
    required TResult Function(String errMsg) invalidOTP,
    required TResult Function(String errMsg) locationError,
    required TResult Function(String errMsg) firebaseException,
    required TResult Function(String errMsg) generalException,
  }) {
    return invalidOTP(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String errMsg)? invalidPhoneNumber,
    TResult? Function(String errMsg)? invalidOTP,
    TResult? Function(String errMsg)? locationError,
    TResult? Function(String errMsg)? firebaseException,
    TResult? Function(String errMsg)? generalException,
  }) {
    return invalidOTP?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String errMsg)? invalidPhoneNumber,
    TResult Function(String errMsg)? invalidOTP,
    TResult Function(String errMsg)? locationError,
    TResult Function(String errMsg)? firebaseException,
    TResult Function(String errMsg)? generalException,
    required TResult orElse(),
  }) {
    if (invalidOTP != null) {
      return invalidOTP(errMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidPhoneNumber value) invalidPhoneNumber,
    required TResult Function(_InvalidOTP value) invalidOTP,
    required TResult Function(_LocationError value) locationError,
    required TResult Function(_FirebaseExcep value) firebaseException,
    required TResult Function(_GeneralException value) generalException,
  }) {
    return invalidOTP(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult? Function(_InvalidOTP value)? invalidOTP,
    TResult? Function(_LocationError value)? locationError,
    TResult? Function(_FirebaseExcep value)? firebaseException,
    TResult? Function(_GeneralException value)? generalException,
  }) {
    return invalidOTP?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult Function(_InvalidOTP value)? invalidOTP,
    TResult Function(_LocationError value)? locationError,
    TResult Function(_FirebaseExcep value)? firebaseException,
    TResult Function(_GeneralException value)? generalException,
    required TResult orElse(),
  }) {
    if (invalidOTP != null) {
      return invalidOTP(this);
    }
    return orElse();
  }
}

abstract class _InvalidOTP implements MainFailure {
  const factory _InvalidOTP({required final String errMsg}) = _$InvalidOTPImpl;

  @override
  String get errMsg;
  @override
  @JsonKey(ignore: true)
  _$$InvalidOTPImplCopyWith<_$InvalidOTPImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LocationErrorImplCopyWith<$Res>
    implements $MainFailureCopyWith<$Res> {
  factory _$$LocationErrorImplCopyWith(
          _$LocationErrorImpl value, $Res Function(_$LocationErrorImpl) then) =
      __$$LocationErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String errMsg});
}

/// @nodoc
class __$$LocationErrorImplCopyWithImpl<$Res>
    extends _$MainFailureCopyWithImpl<$Res, _$LocationErrorImpl>
    implements _$$LocationErrorImplCopyWith<$Res> {
  __$$LocationErrorImplCopyWithImpl(
      _$LocationErrorImpl _value, $Res Function(_$LocationErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = null,
  }) {
    return _then(_$LocationErrorImpl(
      errMsg: null == errMsg
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LocationErrorImpl implements _LocationError {
  const _$LocationErrorImpl({required this.errMsg});

  @override
  final String errMsg;

  @override
  String toString() {
    return 'MainFailure.locationError(errMsg: $errMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationErrorImpl &&
            (identical(other.errMsg, errMsg) || other.errMsg == errMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationErrorImplCopyWith<_$LocationErrorImpl> get copyWith =>
      __$$LocationErrorImplCopyWithImpl<_$LocationErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String errMsg) invalidPhoneNumber,
    required TResult Function(String errMsg) invalidOTP,
    required TResult Function(String errMsg) locationError,
    required TResult Function(String errMsg) firebaseException,
    required TResult Function(String errMsg) generalException,
  }) {
    return locationError(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String errMsg)? invalidPhoneNumber,
    TResult? Function(String errMsg)? invalidOTP,
    TResult? Function(String errMsg)? locationError,
    TResult? Function(String errMsg)? firebaseException,
    TResult? Function(String errMsg)? generalException,
  }) {
    return locationError?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String errMsg)? invalidPhoneNumber,
    TResult Function(String errMsg)? invalidOTP,
    TResult Function(String errMsg)? locationError,
    TResult Function(String errMsg)? firebaseException,
    TResult Function(String errMsg)? generalException,
    required TResult orElse(),
  }) {
    if (locationError != null) {
      return locationError(errMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidPhoneNumber value) invalidPhoneNumber,
    required TResult Function(_InvalidOTP value) invalidOTP,
    required TResult Function(_LocationError value) locationError,
    required TResult Function(_FirebaseExcep value) firebaseException,
    required TResult Function(_GeneralException value) generalException,
  }) {
    return locationError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult? Function(_InvalidOTP value)? invalidOTP,
    TResult? Function(_LocationError value)? locationError,
    TResult? Function(_FirebaseExcep value)? firebaseException,
    TResult? Function(_GeneralException value)? generalException,
  }) {
    return locationError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult Function(_InvalidOTP value)? invalidOTP,
    TResult Function(_LocationError value)? locationError,
    TResult Function(_FirebaseExcep value)? firebaseException,
    TResult Function(_GeneralException value)? generalException,
    required TResult orElse(),
  }) {
    if (locationError != null) {
      return locationError(this);
    }
    return orElse();
  }
}

abstract class _LocationError implements MainFailure {
  const factory _LocationError({required final String errMsg}) =
      _$LocationErrorImpl;

  @override
  String get errMsg;
  @override
  @JsonKey(ignore: true)
  _$$LocationErrorImplCopyWith<_$LocationErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FirebaseExcepImplCopyWith<$Res>
    implements $MainFailureCopyWith<$Res> {
  factory _$$FirebaseExcepImplCopyWith(
          _$FirebaseExcepImpl value, $Res Function(_$FirebaseExcepImpl) then) =
      __$$FirebaseExcepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String errMsg});
}

/// @nodoc
class __$$FirebaseExcepImplCopyWithImpl<$Res>
    extends _$MainFailureCopyWithImpl<$Res, _$FirebaseExcepImpl>
    implements _$$FirebaseExcepImplCopyWith<$Res> {
  __$$FirebaseExcepImplCopyWithImpl(
      _$FirebaseExcepImpl _value, $Res Function(_$FirebaseExcepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = null,
  }) {
    return _then(_$FirebaseExcepImpl(
      errMsg: null == errMsg
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FirebaseExcepImpl implements _FirebaseExcep {
  const _$FirebaseExcepImpl({required this.errMsg});

  @override
  final String errMsg;

  @override
  String toString() {
    return 'MainFailure.firebaseException(errMsg: $errMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FirebaseExcepImpl &&
            (identical(other.errMsg, errMsg) || other.errMsg == errMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FirebaseExcepImplCopyWith<_$FirebaseExcepImpl> get copyWith =>
      __$$FirebaseExcepImplCopyWithImpl<_$FirebaseExcepImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String errMsg) invalidPhoneNumber,
    required TResult Function(String errMsg) invalidOTP,
    required TResult Function(String errMsg) locationError,
    required TResult Function(String errMsg) firebaseException,
    required TResult Function(String errMsg) generalException,
  }) {
    return firebaseException(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String errMsg)? invalidPhoneNumber,
    TResult? Function(String errMsg)? invalidOTP,
    TResult? Function(String errMsg)? locationError,
    TResult? Function(String errMsg)? firebaseException,
    TResult? Function(String errMsg)? generalException,
  }) {
    return firebaseException?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String errMsg)? invalidPhoneNumber,
    TResult Function(String errMsg)? invalidOTP,
    TResult Function(String errMsg)? locationError,
    TResult Function(String errMsg)? firebaseException,
    TResult Function(String errMsg)? generalException,
    required TResult orElse(),
  }) {
    if (firebaseException != null) {
      return firebaseException(errMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidPhoneNumber value) invalidPhoneNumber,
    required TResult Function(_InvalidOTP value) invalidOTP,
    required TResult Function(_LocationError value) locationError,
    required TResult Function(_FirebaseExcep value) firebaseException,
    required TResult Function(_GeneralException value) generalException,
  }) {
    return firebaseException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult? Function(_InvalidOTP value)? invalidOTP,
    TResult? Function(_LocationError value)? locationError,
    TResult? Function(_FirebaseExcep value)? firebaseException,
    TResult? Function(_GeneralException value)? generalException,
  }) {
    return firebaseException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult Function(_InvalidOTP value)? invalidOTP,
    TResult Function(_LocationError value)? locationError,
    TResult Function(_FirebaseExcep value)? firebaseException,
    TResult Function(_GeneralException value)? generalException,
    required TResult orElse(),
  }) {
    if (firebaseException != null) {
      return firebaseException(this);
    }
    return orElse();
  }
}

abstract class _FirebaseExcep implements MainFailure {
  const factory _FirebaseExcep({required final String errMsg}) =
      _$FirebaseExcepImpl;

  @override
  String get errMsg;
  @override
  @JsonKey(ignore: true)
  _$$FirebaseExcepImplCopyWith<_$FirebaseExcepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GeneralExceptionImplCopyWith<$Res>
    implements $MainFailureCopyWith<$Res> {
  factory _$$GeneralExceptionImplCopyWith(_$GeneralExceptionImpl value,
          $Res Function(_$GeneralExceptionImpl) then) =
      __$$GeneralExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String errMsg});
}

/// @nodoc
class __$$GeneralExceptionImplCopyWithImpl<$Res>
    extends _$MainFailureCopyWithImpl<$Res, _$GeneralExceptionImpl>
    implements _$$GeneralExceptionImplCopyWith<$Res> {
  __$$GeneralExceptionImplCopyWithImpl(_$GeneralExceptionImpl _value,
      $Res Function(_$GeneralExceptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errMsg = null,
  }) {
    return _then(_$GeneralExceptionImpl(
      errMsg: null == errMsg
          ? _value.errMsg
          : errMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GeneralExceptionImpl implements _GeneralException {
  const _$GeneralExceptionImpl({required this.errMsg});

  @override
  final String errMsg;

  @override
  String toString() {
    return 'MainFailure.generalException(errMsg: $errMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneralExceptionImpl &&
            (identical(other.errMsg, errMsg) || other.errMsg == errMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneralExceptionImplCopyWith<_$GeneralExceptionImpl> get copyWith =>
      __$$GeneralExceptionImplCopyWithImpl<_$GeneralExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String errMsg) invalidPhoneNumber,
    required TResult Function(String errMsg) invalidOTP,
    required TResult Function(String errMsg) locationError,
    required TResult Function(String errMsg) firebaseException,
    required TResult Function(String errMsg) generalException,
  }) {
    return generalException(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String errMsg)? invalidPhoneNumber,
    TResult? Function(String errMsg)? invalidOTP,
    TResult? Function(String errMsg)? locationError,
    TResult? Function(String errMsg)? firebaseException,
    TResult? Function(String errMsg)? generalException,
  }) {
    return generalException?.call(errMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String errMsg)? invalidPhoneNumber,
    TResult Function(String errMsg)? invalidOTP,
    TResult Function(String errMsg)? locationError,
    TResult Function(String errMsg)? firebaseException,
    TResult Function(String errMsg)? generalException,
    required TResult orElse(),
  }) {
    if (generalException != null) {
      return generalException(errMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InvalidPhoneNumber value) invalidPhoneNumber,
    required TResult Function(_InvalidOTP value) invalidOTP,
    required TResult Function(_LocationError value) locationError,
    required TResult Function(_FirebaseExcep value) firebaseException,
    required TResult Function(_GeneralException value) generalException,
  }) {
    return generalException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult? Function(_InvalidOTP value)? invalidOTP,
    TResult? Function(_LocationError value)? locationError,
    TResult? Function(_FirebaseExcep value)? firebaseException,
    TResult? Function(_GeneralException value)? generalException,
  }) {
    return generalException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InvalidPhoneNumber value)? invalidPhoneNumber,
    TResult Function(_InvalidOTP value)? invalidOTP,
    TResult Function(_LocationError value)? locationError,
    TResult Function(_FirebaseExcep value)? firebaseException,
    TResult Function(_GeneralException value)? generalException,
    required TResult orElse(),
  }) {
    if (generalException != null) {
      return generalException(this);
    }
    return orElse();
  }
}

abstract class _GeneralException implements MainFailure {
  const factory _GeneralException({required final String errMsg}) =
      _$GeneralExceptionImpl;

  @override
  String get errMsg;
  @override
  @JsonKey(ignore: true)
  _$$GeneralExceptionImplCopyWith<_$GeneralExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
