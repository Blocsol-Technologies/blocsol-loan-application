// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvoiceLoanLoginState {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InvoiceLoanLoginStateCopyWith<InvoiceLoanLoginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceLoanLoginStateCopyWith<$Res> {
  factory $InvoiceLoanLoginStateCopyWith(InvoiceLoanLoginState value,
          $Res Function(InvoiceLoanLoginState) then) =
      _$InvoiceLoanLoginStateCopyWithImpl<$Res, InvoiceLoanLoginState>;
  @useResult
  $Res call({String phoneNumber, String deviceId});
}

/// @nodoc
class _$InvoiceLoanLoginStateCopyWithImpl<$Res,
        $Val extends InvoiceLoanLoginState>
    implements $InvoiceLoanLoginStateCopyWith<$Res> {
  _$InvoiceLoanLoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? deviceId = null,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceLoanLoginStateImplCopyWith<$Res>
    implements $InvoiceLoanLoginStateCopyWith<$Res> {
  factory _$$InvoiceLoanLoginStateImplCopyWith(
          _$InvoiceLoanLoginStateImpl value,
          $Res Function(_$InvoiceLoanLoginStateImpl) then) =
      __$$InvoiceLoanLoginStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber, String deviceId});
}

/// @nodoc
class __$$InvoiceLoanLoginStateImplCopyWithImpl<$Res>
    extends _$InvoiceLoanLoginStateCopyWithImpl<$Res,
        _$InvoiceLoanLoginStateImpl>
    implements _$$InvoiceLoanLoginStateImplCopyWith<$Res> {
  __$$InvoiceLoanLoginStateImplCopyWithImpl(_$InvoiceLoanLoginStateImpl _value,
      $Res Function(_$InvoiceLoanLoginStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? deviceId = null,
  }) {
    return _then(_$InvoiceLoanLoginStateImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InvoiceLoanLoginStateImpl implements _InvoiceLoanLoginState {
  const _$InvoiceLoanLoginStateImpl(
      {required this.phoneNumber, required this.deviceId});

  @override
  final String phoneNumber;
  @override
  final String deviceId;

  @override
  String toString() {
    return 'InvoiceLoanLoginState(phoneNumber: $phoneNumber, deviceId: $deviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceLoanLoginStateImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceLoanLoginStateImplCopyWith<_$InvoiceLoanLoginStateImpl>
      get copyWith => __$$InvoiceLoanLoginStateImplCopyWithImpl<
          _$InvoiceLoanLoginStateImpl>(this, _$identity);
}

abstract class _InvoiceLoanLoginState implements InvoiceLoanLoginState {
  const factory _InvoiceLoanLoginState(
      {required final String phoneNumber,
      required final String deviceId}) = _$InvoiceLoanLoginStateImpl;

  @override
  String get phoneNumber;
  @override
  String get deviceId;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceLoanLoginStateImplCopyWith<_$InvoiceLoanLoginStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
